defmodule ElixirMind.DevHistoryTest do
  use ExUnit.Case, async: true

  alias ElixirMind.DevHistory
  alias ElixirMind.DevHistory.Entry

  describe "classify/1 — the three eras of first-parent subjects" do
    test "true merge with a from-branch" do
      assert DevHistory.classify("Merge pull request #67 from ob6to8/claude/three-level-eqptow") ==
               {:merge_from, 67, "ob6to8/claude/three-level-eqptow"}
    end

    test "true merge with an inline title" do
      assert DevHistory.classify("Merge pull request #66: Attribution — ingestion event") ==
               {:merge_titled, 66, "Attribution — ingestion event"}

      assert DevHistory.classify("Merge PR #58: root reorganization") ==
               {:merge_titled, 58, "root reorganization"}
    end

    test "bare merge subject falls back to merge_from with no branch" do
      assert DevHistory.classify("Merge pull request #9") == {:merge_from, 9, nil}
    end

    test "pre-policy squash commit" do
      assert DevHistory.classify("Session-init digest: open work (#39)") ==
               {:squash, 39, "Session-init digest: open work"}
    end

    test "direct commit" do
      assert DevHistory.classify("Add initial second brain architecture plan") == :direct
    end
  end

  describe "humanize_branch/1" do
    test "strips owner, claude/ prefix, and the session-id suffix" do
      assert DevHistory.humanize_branch("ob6to8/claude/deprecated-directory-deletion-myusjh") ==
               "deprecated directory deletion"
    end

    test "nil and empty stay nil" do
      assert DevHistory.humanize_branch(nil) == nil
    end
  end

  describe "squash_bullets/1" do
    test "takes the first line of each * block, ignoring trailers and prose" do
      body = """
      * glossary: add the missing policy pointer entry

      Prompted by the doctrine-vs-policy question.

      Co-Authored-By: Claude <noreply@anthropic.com>

      * capture: 2026-07-11 doctrine-vs-policy

      ---------

      Co-authored-by: Claude <noreply@anthropic.com>
      """

      assert DevHistory.squash_bullets(body) == [
               "glossary: add the missing policy pointer entry",
               "capture: 2026-07-11 doctrine-vs-policy"
             ]
    end
  end

  describe "render_entries/2" do
    setup do
      entries = [
        %Entry{pr: 2, date: "2026-07-02", title: "Second feature", bullets: ["do a", "do b"]},
        %Entry{pr: 1, date: "2026-07-01", title: "First feature", bullets: ["seed"]},
        %Entry{pr: nil, date: "2026-06-30", title: "direct commit"}
      ]

      {:ok, entries: entries}
    end

    test "one section per PR, newest first, with linked PR numbers", %{entries: entries} do
      doc = DevHistory.render_entries(entries, "https://github.com/o/r")

      assert doc =~ "## [PR #2](https://github.com/o/r/pull/2) — Second feature *(2026-07-02)*"
      assert doc =~ "- do a\n- do b"
      assert doc =~ "## Pre-PR era — direct commits"
      assert doc =~ "- 2026-06-30 — direct commit"

      [pos2] = for {s, _} <- :binary.matches(doc, "PR #2]"), do: s
      [pos1] = for {s, _} <- :binary.matches(doc, "PR #1]"), do: s
      assert pos2 < pos1
    end

    test "renders plain PR labels when no repo url is configured", %{entries: entries} do
      doc = DevHistory.render_entries(entries, nil)
      assert doc =~ "## PR #2 — Second feature"
      refute doc =~ "](https://"
    end

    test "no direct commits, no pre-PR section", %{entries: entries} do
      doc = DevHistory.render_entries(Enum.take(entries, 2), nil)
      refute doc =~ "Pre-PR era"
    end
  end

  describe "lagging_but_consistent?/2 — the lag-tolerant check" do
    setup do
      older = [%Entry{pr: 1, date: "2026-07-01", title: "First", bullets: ["seed"]}]
      newer = [%Entry{pr: 2, date: "2026-07-02", title: "Second", bullets: ["more"]} | older]

      {:ok,
       disk: DevHistory.render_entries(older, nil), fresh: DevHistory.render_entries(newer, nil)}
    end

    test "a file lacking only newer sections is consistent", %{disk: disk, fresh: fresh} do
      assert DevHistory.lagging_but_consistent?(fresh, disk)
    end

    test "a hand-edited older section diverges", %{disk: disk, fresh: fresh} do
      edited = String.replace(disk, "- seed", "- tampered")
      refute DevHistory.lagging_but_consistent?(fresh, edited)
    end

    test "an empty or sectionless file diverges", %{fresh: fresh} do
      refute DevHistory.lagging_but_consistent?(fresh, "")
      refute DevHistory.lagging_but_consistent?(fresh, "# Dev history\n\nno sections")
    end
  end

  describe "against the live repo" do
    test "derivation and check run green on this checkout" do
      # Guard: sandboxes may hand us a shallow clone; derivation is untestable there.
      unless ElixirMind.DevHistory.shallow?() do
        assert {:ok, entries} = DevHistory.entries()
        assert Enum.any?(entries, &(&1.pr != nil))
        assert :ok = DevHistory.check()
      end
    end
  end
end
