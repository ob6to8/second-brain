defmodule ElixirMind.RouteTagsTest do
  use ExUnit.Case, async: true

  alias ElixirMind.RouteTags

  # ---------------------------------------------------------------------
  # parse_regions/1
  # ---------------------------------------------------------------------

  describe "parse_regions/1" do
    test "extracts a balanced region with its ref set and content" do
      body = """
      ## Assistant

      <routes ref="sb:abc123 code/loop.ex">

      First paragraph.

      Second paragraph.

      </routes>
      """

      {[region], []} = RouteTags.parse_regions(body)
      assert region.refs == ["sb:abc123", "code/loop.ex"]
      assert region.line == 3
      assert Enum.join(region.content, "\n") =~ "First paragraph."
    end

    test "ignores tag syntax mentioned inside fenced code" do
      body = """
      The syntax looks like:

      ```
      <routes ref="sb:abc123">
      ... a paragraph ...
      </routes>
      ```
      """

      assert {[], []} = RouteTags.parse_regions(body)
    end

    test "ignores tag syntax not anchored at line start" do
      body = """
      Scan threads for `<routes ref="sb:abc123">` to find regions.
      """

      assert {[], []} = RouteTags.parse_regions(body)
    end

    test "reports an unclosed region" do
      body = """
      <routes ref="sb:abc123">
      dangling
      """

      {[], [problem]} = RouteTags.parse_regions(body)
      assert problem =~ "unclosed"
      assert problem =~ "line 1"
    end

    test "reports an unmatched close" do
      {[], [problem]} = RouteTags.parse_regions("</routes>\n")
      assert problem =~ "unmatched </routes> at line 1"
    end

    test "reports nesting" do
      body = """
      <routes ref="sb:aaa111">
      <routes ref="sb:bbb222">
      </routes>
      """

      {[region], [problem]} = RouteTags.parse_regions(body)
      assert problem =~ "nested"
      assert region.refs == ["sb:aaa111"]
    end

    test "reports a region crossing a turn boundary" do
      body = """
      <routes ref="sb:abc123">
      tail of one turn

      ## User

      next turn
      """

      {[], [problem]} = RouteTags.parse_regions(body)
      assert problem =~ "crosses a turn boundary at line 4"
    end

    test "reports an empty ref set" do
      body = """
      <routes ref="">
      </routes>
      """

      {_, [problem]} = RouteTags.parse_regions(body)
      assert problem =~ "empty ref set"
    end
  end

  # ---------------------------------------------------------------------
  # classification
  # ---------------------------------------------------------------------

  describe "classify_ref/1" do
    test "sb: ids are concept sinks, everything else is a path back-link" do
      assert RouteTags.classify_ref("sb:b57200") == {:doc, "sb:b57200"}

      assert RouteTags.classify_ref("lib/elixir_mind/route_tags.ex") ==
               {:path, "lib/elixir_mind/route_tags.ex"}

      assert RouteTags.classify_ref("/SWE/agentic-coding/foo.md") ==
               {:path, "/SWE/agentic-coding/foo.md"}
    end

    test "doc_refs keeps only concept sinks, in ref order" do
      refs = ["sb:aaa111", "code/loop.ex", "sb:bbb222", "docs/x.md"]
      assert RouteTags.doc_refs(refs) == ["sb:aaa111", "sb:bbb222"]
    end
  end

  # ---------------------------------------------------------------------
  # derivation
  # ---------------------------------------------------------------------

  describe "demote_headers/1" do
    test "demotes ATX headers to bold" do
      assert RouteTags.demote_headers(["## The design", "prose"]) ==
               ["**The design**", "prose"]
    end

    test "leaves headers inside fenced code untouched" do
      lines = ["```", "## not a header", "```", "## a header"]
      assert RouteTags.demote_headers(lines) == ["```", "## not a header", "```", "**a header**"]
    end
  end

  describe "derive_block/3" do
    setup do
      thread = %{slug: "2026-07-08-example-thread", date: "2026-07-08"}

      regions = [
        %{refs: ["sb:aaa111"], line: 1, content: ["Only this matter."]},
        %{
          refs: ["sb:aaa111", "sb:bbb222", "code/loop.ex"],
          line: 9,
          content: ["", "## Inner header", "", "Shared paragraph.", ""]
        }
      ]

      %{thread: thread, regions: regions}
    end

    test "renders header, count line, co-feeds, and demoted content", ctx do
      block = RouteTags.derive_block("sb:aaa111", ctx.thread, ctx.regions)

      assert block =~ "### 2026-07-08-example-thread (2026-07-08)"
      assert block =~ "2 tagged region(s), lifted whole."
      assert block =~ "**[`sb:aaa111`]**\n\nOnly this matter."
      assert block =~ "**[`sb:aaa111`]**  (co-feeds: `sb:bbb222 code/loop.ex`)"
      assert block =~ "**Inner header**\n\nShared paragraph."
      refute block =~ "## Inner header"
    end

    test "each sink sees the region under its own key with the rest as co-feeds", ctx do
      block = RouteTags.derive_block("sb:bbb222", ctx.thread, [Enum.at(ctx.regions, 1)])
      assert block =~ "**[`sb:bbb222`]**  (co-feeds: `sb:aaa111 code/loop.ex`)"
    end
  end

  # ---------------------------------------------------------------------
  # log-section parsing
  # ---------------------------------------------------------------------

  describe "parse_log_section/1" do
    test "returns nil when the document carries no log section" do
      assert RouteTags.parse_log_section("## Thread excerpts (hand-picked)\n\nquote\n") == nil
    end

    test "splits per-thread blocks and stops at the next section" do
      doc = """
      ## Thread excerpts — route-tagged log

      Preamble kept out of any block.

      ### 2026-07-01-first-thread (2026-07-01)

      1 tagged region(s), lifted whole.

      **[`sb:aaa111`]**

      A block.

      ### 2026-07-02-second-thread (2026-07-02)

      more

      ## Related

      - not part of the log
      """

      blocks = RouteTags.parse_log_section(doc)

      assert Map.keys(blocks) |> Enum.sort() == [
               "2026-07-01-first-thread",
               "2026-07-02-second-thread"
             ]

      assert Enum.join(blocks["2026-07-01-first-thread"], "\n") =~ "A block."
      refute Enum.join(blocks["2026-07-02-second-thread"], "\n") =~ "Related"
    end
  end

  # ---------------------------------------------------------------------
  # run_checks/1 on a fixture tree
  # ---------------------------------------------------------------------

  describe "run_checks/1" do
    setup %{tmp_dir: root} do
      File.mkdir_p!(Path.join(root, "meta/threads"))
      File.mkdir_p!(Path.join(root, "kb"))
      File.mkdir_p!(Path.join(root, "code"))
      File.write!(Path.join(root, "code/loop.ex"), "code artifact\n")
      %{root: root}
    end

    defp write_thread(root, slug, body) do
      File.write!(Path.join(root, "meta/threads/#{slug}.md"), body)
    end

    defp write_concept(root, slug, id, body) do
      File.write!(
        Path.join(root, "kb/#{slug}.md"),
        "---\nid: #{id}\ntype: concept\ntitle: #{slug}\n---\n\n" <> body
      )
    end

    defp statuses(results), do: Map.new(results, fn {name, status, _} -> {name, status} end)

    defp green_fixture(root) do
      write_thread(root, "2026-07-08-example-thread", """
      ## Routing

      | Topic | State | Routed to | Dangling |
      |---|---|---|---|
      | The matter | closed | [some-doc](/kb/some-doc.md) | - |

      ## Assistant

      <routes ref="sb:aaa111 code/loop.ex">

      The paragraph.

      </routes>
      """)

      write_concept(root, "some-doc", "sb:aaa111", """
      # Some doc

      ## Thread excerpts — route-tagged log

      ### 2026-07-08-example-thread (2026-07-08)

      1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

      **[`sb:aaa111`]**  (co-feeds: `code/loop.ex`)

      The paragraph.
      """)
    end

    @tag :tmp_dir
    test "a consistent corpus passes every check", %{root: root} do
      green_fixture(root)
      results = RouteTags.run_checks(root)
      assert Enum.all?(results, fn {_, status, _} -> status == :ok end), inspect(results)
    end

    @tag :tmp_dir
    test "an unresolved ref fails resolution", %{root: root} do
      green_fixture(root)
      # Point the tag at an id no concept carries.
      path = Path.join(root, "meta/threads/2026-07-08-example-thread.md")

      File.write!(
        path,
        String.replace(File.read!(path), "sb:aaa111 code/loop.ex", "sb:dead00 code/loop.ex")
      )

      results = RouteTags.run_checks(root)
      assert statuses(results)["ref resolution"] == :fail
    end

    @tag :tmp_dir
    test "a tagged sink without a dated block fails sink logs", %{root: root} do
      green_fixture(root)
      write_concept(root, "some-doc", "sb:aaa111", "# Some doc\n\nno log section\n")
      results = RouteTags.run_checks(root)
      assert statuses(results)["sink logs"] == :fail
    end

    @tag :tmp_dir
    test "a block that diverges from its re-derivation fails fidelity", %{root: root} do
      green_fixture(root)
      path = Path.join(root, "kb/some-doc.md")

      File.write!(
        path,
        String.replace(File.read!(path), "The paragraph.", "A trimmed paraphrase.")
      )

      results = RouteTags.run_checks(root)
      assert statuses(results)["log fidelity"] == :fail
    end

    @tag :tmp_dir
    test "a block for a thread that no longer tags the sink is an orphan", %{root: root} do
      green_fixture(root)

      write_concept(root, "other-doc", "sb:ccc333", """
      # Other doc

      ## Thread excerpts — route-tagged log

      ### 2026-07-08-example-thread (2026-07-08)

      stale block
      """)

      results = RouteTags.run_checks(root)
      {_, :fail, detail} = Enum.find(results, &(elem(&1, 0) == "log fidelity"))
      assert detail =~ "sb:ccc333"
      assert detail =~ "no longer tags this sink"
    end

    @tag :tmp_dir
    test "a concept-routed ledger row with no covering tag warns, not fails", %{root: root} do
      green_fixture(root)
      write_concept(root, "uncovered-doc", "sb:ddd444", "# Uncovered\n")

      write_thread(root, "2026-07-09-second-thread", """
      ## Routing

      | Topic | State | Routed to | Dangling |
      |---|---|---|---|
      | Another matter | open | [uncovered-doc](/kb/uncovered-doc.md) | - |

      ## Assistant

      Untagged body.
      """)

      results = RouteTags.run_checks(root)
      {_, :warn, detail} = Enum.find(results, &(elem(&1, 0) == "ledger cross-check"))
      assert detail =~ "2026-07-09-second-thread"
      assert Enum.count(results, fn {_, s, _} -> s == :fail end) == 0
    end

    @tag :tmp_dir
    test "a pipe table outside the ## Routing section is not read as the ledger", %{root: root} do
      green_fixture(root)
      write_concept(root, "quoted-doc", "sb:eee555", "# Quoted\n")

      # A quoted comparison table whose 4th column links a concept — it is not
      # the ledger and must not produce a ledger-coverage warning.
      write_thread(root, "2026-07-09-quoting-thread", """
      ## Routing

      | Topic | State | Routed to | Dangling |
      |---|---|---|---|
      | The only strand | closed | unrouted | - |

      ## Assistant

      | Tool | Kind | Docs | Notes |
      |---|---|---|---|
      | brain.verify | gate | [quoted-doc](/kb/quoted-doc.md) | quoted table |
      """)

      results = RouteTags.run_checks(root)
      assert statuses(results)["ledger cross-check"] == :ok
    end

    @tag :tmp_dir
    test "materialize/1 writes a log section that then verifies", %{root: root} do
      # Thread + sink with the tag but NO log section yet.
      write_thread(root, "2026-07-08-example-thread", """
      ## Assistant

      <routes ref="sb:aaa111">

      The paragraph.

      </routes>
      """)

      write_concept(root, "some-doc", "sb:aaa111", "# Some doc\n\nBody prose.\n")

      assert ["kb/some-doc.md"] = RouteTags.materialize(root)

      results = RouteTags.run_checks(root)
      assert Enum.all?(results, fn {_, s, _} -> s in [:ok, :warn] end), inspect(results)
      assert statuses(results)["log fidelity"] == :ok
      assert statuses(results)["sink logs"] == :ok
    end
  end

  # ---------------------------------------------------------------------
  # the live bundle
  # ---------------------------------------------------------------------

  describe "the bundle" do
    test "carries no route-tag failures" do
      results = RouteTags.run_checks(".")
      failures = Enum.filter(results, fn {_, status, _} -> status == :fail end)
      assert failures == [], inspect(failures, pretty: true)
    end
  end
end
