defmodule SecondBrain.LineageTest do
  use ExUnit.Case, async: true

  alias SecondBrain.Lineage
  alias SecondBrain.Lineage.Flow

  @moduletag :tmp_dir

  # Lineage derives from the flow doc's `attribution.from` refs (classified by
  # governance path) plus each thread doc's `pr:` anchor.
  defp write_flow(dir, slug, from_refs, body \\ "Body prose.") do
    path = Path.join([dir, "meta", "flows", "#{slug}.md"])
    File.mkdir_p!(Path.dirname(path))

    attribution =
      "attribution:\n  when: 2026-07-13T10:00:00Z\n  channel: agent-authored\n" <>
        "  agent: \"test fixture\"\n  why: \"probe\"\n" <>
        case from_refs do
          [] -> ""
          refs -> "  from: [" <> Enum.join(refs, ", ") <> "]\n"
        end

    fm = "---\ntype: note\ntitle: \"Flow #{slug}\"\n" <> attribution <> "---\n"
    File.write!(path, fm <> "\n# Flow #{slug}\n\n" <> body <> "\n")
    path
  end

  defp write_doc(dir, rel, title, extra \\ "") do
    path = Path.join(dir, rel)
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, "---\ntype: plan\ntitle: \"#{title}\"\n#{extra}---\nbody\n")
  end

  defp write_thread(dir, rel, title, pr),
    do: write_doc(dir, rel, title, "pr: #{pr}\n")

  describe "parse_lineage_block/1 (migration reader)" do
    test "reads scalars, block lists, inline lists, and integers" do
      content = """
      ---
      type: note
      title: x
      lineage:
        analysis: /meta/analysis/a.md
        plan:
          - /meta/plans/p1.md
          - /meta/plans/p2.md
        pr: [24, 25]
      timestamp: 2026-07-12
      ---
      # x
      """

      parsed = Lineage.parse_lineage_block(content)
      assert parsed[:analysis] == ["/meta/analysis/a.md"]
      assert parsed[:plan] == ["/meta/plans/p1.md", "/meta/plans/p2.md"]
      assert parsed[:pr] == [24, 25]
      refute Map.has_key?(parsed, :thread)
    end

    test "empty map when there is no lineage block" do
      assert Lineage.parse_lineage_block("---\ntype: note\ntitle: x\n---\n# x\n") == %{}
    end
  end

  describe "scan/1 + blockquote/1" do
    setup %{tmp_dir: dir} do
      write_doc(dir, "meta/analysis/probe.md", "The Probe Analysis")
      write_doc(dir, "meta/plans/probe.md", "The Probe Plan")
      write_thread(dir, "meta/threads/2026-07-12-probe.md", "Probe Session", 50)
      :ok
    end

    test "full chain renders every hop with resolved titles", %{tmp_dir: dir} do
      write_flow(dir, "probe", [
        "/meta/analysis/probe.md",
        "/meta/plans/probe.md",
        "/meta/threads/2026-07-12-probe.md"
      ])

      [flow] = Lineage.scan(dir)
      assert flow.pr == [50]
      q = Lineage.blockquote(flow)
      assert q =~ "Identified in [The Probe Analysis](/meta/analysis/probe.md)"
      assert q =~ "designed in [The Probe Plan](/meta/plans/probe.md)"
      assert q =~ "built in [Probe Session](/meta/threads/2026-07-12-probe.md)"
      assert q =~ "merged in PR #50"
    end

    test "omitted hops are skipped and the first phrase is capitalized", %{tmp_dir: dir} do
      write_thread(dir, "meta/threads/2026-07-12-other.md", "Other Session", 46)
      write_flow(dir, "probe", ["/meta/threads/2026-07-12-other.md"])

      [flow] = Lineage.scan(dir)
      q = Lineage.blockquote(flow)
      assert q =~ "Built in [Other Session]"
      assert q =~ "merged in PR #46"
      refute q =~ "designed in"
      refute q =~ "identified in"
    end

    test "two threads aggregate both PRs in order", %{tmp_dir: dir} do
      write_thread(dir, "meta/threads/2026-07-13-second.md", "Second Session", 61)

      write_flow(dir, "probe", [
        "/meta/threads/2026-07-12-probe.md",
        "/meta/threads/2026-07-13-second.md"
      ])

      [flow] = Lineage.scan(dir)
      assert flow.pr == [50, 61]
    end

    test "a flow with no from refs has no blockquote", %{tmp_dir: dir} do
      write_flow(dir, "bare", [])
      [flow] = Lineage.scan(dir)
      refute Flow.has_lineage?(flow)
      assert Lineage.blockquote(flow) == nil
    end
  end

  describe "materialize/2" do
    test "inserts after the H1, then replaces in place (idempotent)", %{tmp_dir: dir} do
      write_thread(dir, "meta/threads/2026-07-12-probe.md", "Probe Session", 7)
      path = write_flow(dir, "probe", ["/meta/threads/2026-07-12-probe.md"])

      [flow] = Lineage.scan(dir)
      content = File.read!(path)
      once = Lineage.materialize(flow, content)

      assert once =~ "<!-- lineage:start"
      assert once =~ "<!-- lineage:end -->"
      # block sits directly under the H1
      assert once =~ ~r/# Flow probe\n\n<!-- lineage:start/

      twice = Lineage.materialize(flow, once)
      assert twice == once
      assert once =~ "lineage:start" and count(once, "lineage:start") == 1
    end
  end

  describe "write/1 + check/1 + render_index/1" do
    setup %{tmp_dir: dir} do
      write_doc(dir, "meta/plans/probe.md", "The Probe Plan")
      write_thread(dir, "meta/threads/2026-07-12-probe.md", "Probe Session", 50)

      write_flow(dir, "probe", [
        "/meta/plans/probe.md",
        "/meta/threads/2026-07-12-probe.md"
      ])

      write_flow(dir, "bare", [])
      :ok
    end

    test "index carries a mermaid chart, a table row, and a no-lineage section", %{tmp_dir: dir} do
      idx = Lineage.render_index(dir)
      assert idx =~ "```mermaid"
      assert idx =~ "flowchart LR"
      assert idx =~ "PR #50"
      assert idx =~ "[The Probe Plan](/meta/plans/probe.md)"
      assert idx =~ "No lineage recorded yet"
      assert idx =~ "[Flow bare](/meta/flows/bare.md)"
    end

    test "write then check is :ok (idempotent), and an upstream pr: edit goes stale", %{
      tmp_dir: dir
    } do
      assert Lineage.index_output_path() in Lineage.write(dir)
      assert Lineage.check(dir) == :ok

      # writing again is a no-op
      assert Lineage.write(dir) == []
      assert Lineage.check(dir) == :ok

      # change the thread's PR anchor -> the derived views are now stale
      thread = Path.join([dir, "meta", "threads", "2026-07-12-probe.md"])
      File.write!(thread, String.replace(File.read!(thread), "pr: 50", "pr: 51"))
      assert {:stale, stale} = Lineage.check(dir)
      assert "meta/flows/probe.md" in stale
    end
  end

  defp count(haystack, needle),
    do: haystack |> String.split(needle) |> length() |> Kernel.-(1)
end
