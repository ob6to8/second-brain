defmodule ElixirMind.CaptureScenarioTest do
  # Scenario test for the capture flow's deterministic spine (see
  # meta/flows/session-capture.md and meta/plans/flows-genre-and-scenario-testing.md).
  #
  # Per the harness research spike, this is plain ExUnit over a `:tmp_dir` bundle,
  # with in-code fixtures and structured + targeted assertions — NOT an on-disk
  # whole-tree golden. The oracle is threefold: `materialize/1`'s change-set,
  # `run_checks/1`'s statuses, and one targeted assertion on the materialized log
  # section that PINS the transform (co-feed lifting, ATX→bold demotion, count
  # line, cross-thread ordering) — the exact output that the self-consistency
  # `log fidelity` check cannot pin on its own.
  use ExUnit.Case, async: true

  alias ElixirMind.RouteTags

  @moduletag :tmp_dir

  @agg_rel "kb/routing-aggregator.md"

  setup %{tmp_dir: root} do
    File.mkdir_p!(Path.join(root, "meta/threads"))
    File.mkdir_p!(Path.join(root, "kb"))
    File.mkdir_p!(Path.join(root, "code"))
    File.write!(Path.join(root, "code/loop.ex"), "code artifact\n")

    # Two threads feed the same concept sink. Thread alpha carries a multi-ref
    # region (a concept id co-feeding a path back-link) whose body contains an ATX
    # header; thread beta carries a single-ref region. Materializing the sink must
    # lift both, demote the header, and order the dated blocks by slug.
    write_thread(root, "2026-07-08-alpha", """
    ## Routing

    | Topic | State | Routed to | Dangling |
    |---|---|---|---|
    | Alpha matter | closed | [agg](/kb/routing-aggregator.md) | - |

    ## Assistant

    <routes ref="sb:aaa111 code/loop.ex">

    ## A heading

    Alpha body paragraph.

    </routes>
    """)

    write_thread(root, "2026-07-09-beta", """
    ## Routing

    | Topic | State | Routed to | Dangling |
    |---|---|---|---|
    | Beta matter | closed | [agg](/kb/routing-aggregator.md) | - |

    ## Assistant

    <routes ref="sb:aaa111">

    Beta body paragraph.

    </routes>
    """)

    # The sink concept exists but carries NO log section yet — materialize writes it.
    write_concept(
      root,
      "routing-aggregator",
      "sb:aaa111",
      "# Routing aggregator\n\nBody prose.\n"
    )

    %{root: root}
  end

  # The exact log section materialize must write into the sink. This string is the
  # transform's contract: the co-feeds line for the multi-ref region, the ATX
  # header demoted to bold, the count line, and alpha-before-beta ordering.
  @expected_section """
  ## Thread excerpts — route-tagged log

  Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:aaa111">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

  ### 2026-07-08-alpha (2026-07-08)

  1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

  **[`sb:aaa111`]**  (co-feeds: `code/loop.ex`)

  **A heading**

  Alpha body paragraph.

  ### 2026-07-09-beta (2026-07-09)

  1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

  **[`sb:aaa111`]**

  Beta body paragraph.\
  """

  test "materialize writes the expected log and the bundle then checks clean", %{root: root} do
    # Structured oracle: only the one fed concept sink is rewritten.
    assert RouteTags.materialize(root) == [@agg_rel]

    # Targeted oracle: the materialized section is byte-exact — this is what pins
    # the transform against a wrong-but-self-consistent change.
    assert File.read!(Path.join(root, @agg_rel)) =~ @expected_section

    # Structured oracle: every check passes after materialization.
    statuses = Map.new(RouteTags.run_checks(root), fn {name, status, _} -> {name, status} end)

    assert statuses == %{
             "tag wellformedness" => :ok,
             "ref resolution" => :ok,
             "sink logs" => :ok,
             "log fidelity" => :ok,
             "ledger cross-check" => :ok
           }
  end

  test "re-materializing is idempotent", %{root: root} do
    assert RouteTags.materialize(root) == [@agg_rel]
    once = File.read!(Path.join(root, @agg_rel))

    assert RouteTags.materialize(root) == [@agg_rel]
    assert File.read!(Path.join(root, @agg_rel)) == once
  end

  # The two-directional projection: a sink whose last feeding thread stops
  # tagging it loses its whole log section on the next materialize — no flag,
  # no hand-edit (see meta/plans/code-review-toolchain-hardening.md P1).
  test "materialize removes the section of a sink no longer fed", %{root: root} do
    assert RouteTags.materialize(root) == [@agg_rel]
    assert File.read!(Path.join(root, @agg_rel)) =~ "## Thread excerpts"

    # Both threads drop their tags (and routing rows) — the sink is now unfed.
    write_thread(root, "2026-07-08-alpha", "## Assistant\n\nNo tags anymore.\n")
    write_thread(root, "2026-07-09-beta", "## Assistant\n\nNone here either.\n")

    # The removal is reported like any other materialized change.
    assert RouteTags.materialize(root) == [@agg_rel]

    content = File.read!(Path.join(root, @agg_rel))
    refute content =~ "## Thread excerpts"
    assert content =~ "Body prose."

    statuses = Map.new(RouteTags.run_checks(root), fn {name, status, _} -> {name, status} end)
    assert Enum.all?(Map.values(statuses), &(&1 == :ok))
  end

  test "a still-fed sink drops the block of a thread that stopped tagging it", %{root: root} do
    assert RouteTags.materialize(root) == [@agg_rel]

    # Alpha stops tagging; beta still feeds the sink.
    write_thread(root, "2026-07-08-alpha", "## Assistant\n\nNo tags anymore.\n")

    assert RouteTags.materialize(root) == [@agg_rel]
    content = File.read!(Path.join(root, @agg_rel))

    assert content =~ "### 2026-07-09-beta"
    refute content =~ "### 2026-07-08-alpha"

    statuses = Map.new(RouteTags.run_checks(root), fn {name, status, _} -> {name, status} end)
    assert Enum.all?(Map.values(statuses), &(&1 == :ok))
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
end
