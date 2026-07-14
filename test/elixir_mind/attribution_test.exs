defmodule ElixirMind.AttributionTest do
  use ExUnit.Case, async: false

  alias ElixirMind.{Attribution, Verifier}

  @moduletag :tmp_dir

  defp write_doc(dir, rel_path, fm_lines, body \\ "Body.") do
    path = Path.join(dir, rel_path)
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, "---\n#{String.trim_trailing(fm_lines, "\n")}\n---\n#{body}\n")
  end

  defp attribution_block(overrides \\ []) do
    fields =
      Keyword.merge(
        [
          when: "2026-07-13T14:02:00Z",
          channel: "intake",
          agent: "\"operator via /intake\"",
          why: "\"operator asked to file it\""
        ],
        overrides
      )

    lines =
      fields
      |> Enum.reject(fn {_k, v} -> v == :omit end)
      |> Enum.map_join("\n", fn {k, v} -> "  #{k}: #{v}" end)

    "attribution:\n" <> lines
  end

  describe "bundle concepts" do
    test "a well-formed attribution passes", %{tmp_dir: dir} do
      write_doc(dir, "concept.md", "type: note\nid: sb:aaaaaa\n" <> attribution_block())
      assert Verifier.run(dir) == :ok
    end

    test "shape violations are flagged", %{tmp_dir: dir} do
      write_doc(
        dir,
        "bad.md",
        "type: note\nid: sb:aaaaaa\n" <>
          attribution_block(
            when: "sometime-in-july",
            channel: "carrier-pigeon",
            agent: :omit,
            why: :omit
          )
      )

      assert {:error, errors} = Verifier.run(dir)
      joined = Enum.join(errors, "\n")

      assert joined =~ ~s(`when` "sometime-in-july" is not ISO 8601)
      assert joined =~ ~s(channel "carrier-pigeon" is not in the controlled vocabulary)
      assert joined =~ "missing `agent`"
      assert joined =~ "missing `why`"
    end

    test "a bare date `when` and a backfill without `why` are both fine", %{tmp_dir: dir} do
      write_doc(
        dir,
        "backfilled.md",
        "type: note\nid: sb:aaaaaa\n" <>
          attribution_block(when: "2026-07-01", channel: "backfill", why: :omit)
      )

      assert Verifier.run(dir) == :ok
    end

    test "a non-map attribution is flagged", %{tmp_dir: dir} do
      write_doc(dir, "flat.md", "type: note\nid: sb:aaaaaa\nattribution: intake 2026-07-13")
      assert {:error, errors} = Verifier.run(dir)
      assert Enum.join(errors, "\n") =~ "`attribution` is not a map"
    end

    test "`from` on a bundle concept is flagged", %{tmp_dir: dir} do
      write_doc(
        dir,
        "concept.md",
        "type: note\nid: sb:aaaaaa\n" <> attribution_block() <> "\n  from: [sb:aaaaaa]"
      )

      assert {:error, errors} = Verifier.run(dir)
      assert Enum.join(errors, "\n") =~ "`from` on a bundle concept"
    end

    test "presence is enforced by default (post-backfill), relaxable via presence: false", %{
      tmp_dir: dir
    } do
      write_doc(dir, "bare.md", "type: note\nid: sb:aaaaaa")

      assert {:error, errors} = Verifier.run(dir)
      assert Enum.join(errors, "\n") =~ "bare.md: missing `attribution`"
      assert Verifier.run(dir, presence: false) == :ok
    end
  end

  describe "governance docs" do
    test "attribution with resolving `from` refs passes", %{tmp_dir: dir} do
      write_doc(dir, "concept.md", "type: note\nid: sb:aaaaaa\n" <> attribution_block())
      write_doc(dir, "meta/threads/2026-07-13-session.md", "type: reference")

      write_doc(
        dir,
        "meta/plans/some-plan.md",
        "type: plan\n" <>
          attribution_block(channel: "agent-authored") <>
          "\n  from: [/meta/threads/2026-07-13-session.md, sb:aaaaaa]"
      )

      assert Verifier.run(dir) == :ok
      assert Attribution.warnings(dir) == []
    end

    test "dangling `from` refs are flagged", %{tmp_dir: dir} do
      write_doc(
        dir,
        "meta/plans/some-plan.md",
        "type: plan\n" <>
          attribution_block(channel: "agent-authored") <>
          "\n  from: [/meta/threads/missing.md, sb:ffffff]"
      )

      assert {:error, errors} = Verifier.run(dir)
      joined = Enum.join(errors, "\n")
      assert joined =~ ~s(from "/meta/threads/missing.md" does not resolve)
      assert joined =~ ~s(from "sb:ffffff" does not resolve)
    end

    test "attribution on an exempt file is flagged", %{tmp_dir: dir} do
      write_doc(
        dir,
        "meta/threads/2026-07-13-session.md",
        "type: reference\n" <> attribution_block()
      )

      assert {:error, errors} = Verifier.run(dir)
      assert Enum.join(errors, "\n") =~ "exempt file carries `attribution`"
    end

    test "governance presence is enforced by default, relaxable via presence: false", %{
      tmp_dir: dir
    } do
      write_doc(dir, "meta/plans/bare-plan.md", "type: plan")

      assert {:error, errors} = Verifier.run(dir)
      assert Enum.join(errors, "\n") =~ "bare-plan.md: missing `attribution`"
      assert Verifier.run(dir, presence: false) == :ok
    end

    test "list/2 spans bundle and governance rows with channel/since filters", %{tmp_dir: dir} do
      write_doc(
        dir,
        "concept.md",
        "type: note\nid: sb:aaaaaa\n" <> attribution_block(when: "2026-07-10T08:00:00Z")
      )

      write_doc(
        dir,
        "meta/plans/some-plan.md",
        "type: plan\n" <> attribution_block(channel: "agent-authored", when: "2026-07-12")
      )

      all = Attribution.list(dir)
      assert Enum.map(all, & &1.path) == ["meta/plans/some-plan.md", "concept.md"]
      assert %{id: "sb:aaaaaa", channel: "intake"} = List.last(all)

      assert [%{path: "concept.md"}] = Attribution.list(dir, channel: "intake")
      assert [%{path: "meta/plans/some-plan.md"}] = Attribution.list(dir, since: "2026-07-11")
      assert Attribution.list(dir, channel: "intake", since: "2026-07-11") == []
    end

    test "a ratification-flow doc without `from` warns (advisory)", %{tmp_dir: dir} do
      write_doc(
        dir,
        "meta/plans/some-plan.md",
        "type: plan\n" <> attribution_block(channel: "agent-authored")
      )

      assert Verifier.run(dir) == :ok
      assert [warning] = Attribution.warnings(dir)
      assert warning =~ "some-plan.md: `attribution` lacks `from`"

      # Non-ratification-flow governance docs don't warn.
      write_doc(
        dir,
        "meta/tutorials/some-tutorial.md",
        "type: tutorial\n" <> attribution_block(channel: "agent-authored")
      )

      assert [^warning] = Attribution.warnings(dir)
    end
  end
end
