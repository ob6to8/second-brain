defmodule SecondBrain.RegistryTest do
  use ExUnit.Case, async: false

  alias SecondBrain.{Registry, Verifier}

  @moduletag :tmp_dir

  defp write_concept(dir, rel_path, fields, body \\ "Body.") do
    path = Path.join(dir, rel_path)
    File.mkdir_p!(Path.dirname(path))
    fm = Enum.map_join(fields, "\n", fn {k, v} -> "#{k}: #{v}" end)
    File.write!(path, "---\n#{fm}\n---\n#{body}\n")
  end

  test "scan finds bundle concepts, skips reserved files and excluded dirs", %{tmp_dir: dir} do
    write_concept(dir, "a/b/concept.md", type: "note", id: "sb:aaaaaa")
    File.mkdir_p!(Path.join(dir, "a"))
    File.write!(Path.join(dir, "a/index.md"), "# a\n")
    write_concept(dir, "meta/policy/rule.md", type: "policy")
    write_concept(dir, "deprecated/old.md", type: "note")

    {entries, errors} = Registry.scan(dir)

    assert errors == []
    assert Enum.map(entries, & &1.path) == ["a/b/concept.md"]
    assert hd(entries).concept_id == "a/b/concept.md" |> String.trim_trailing(".md")
  end

  test "scan reports duplicate ids", %{tmp_dir: dir} do
    write_concept(dir, "one.md", type: "note", id: "sb:aaaaaa")
    write_concept(dir, "two.md", type: "note", id: "sb:aaaaaa")

    {_entries, errors} = Registry.scan(dir)
    assert [error] = errors
    assert error =~ "duplicate id sb:aaaaaa"
  end

  test "mint produces well-formed, collision-free ids" do
    taken = MapSet.new(["sb:aaaaaa"])
    id = Registry.mint(taken)
    assert id =~ Registry.id_format()
    refute MapSet.member?(taken, id)
  end

  test "registry view write/check round-trips and detects staleness", %{tmp_dir: dir} do
    write_concept(dir, "one.md", type: "note", id: "sb:aaaaaa", title: "One")
    File.mkdir_p!(Path.join(dir, "meta"))

    Registry.write(dir)
    assert Registry.check(dir) == :ok

    write_concept(dir, "two.md", type: "note", id: "sb:bbbbbb", title: "Two")
    assert {:stale, _} = Registry.check(dir)
  end

  describe "Verifier.run/1" do
    test "passes a well-formed bundle: statement verified via a link-storing capture", %{
      tmp_dir: dir
    } do
      # A capture: stores a link, so it is evidence — never itself `verified`.
      write_concept(dir, "src.md",
        type: "source",
        id: "sb:aaaaaa",
        resource: "https://example.org/doc"
      )

      # An agent statement: verified via an evidence edge to the capture.
      write_concept(dir, "claim.md",
        type: "concept",
        id: "sb:bbbbbb",
        verified: true,
        verified_by: "[sb:aaaaaa]"
      )

      assert Verifier.run(dir) == :ok
    end

    test "flags missing id, dangling edge, verified capture, and evidence-less verified", %{
      tmp_dir: dir
    } do
      write_concept(dir, "no-id.md", type: "note")

      # verified: true on a link-storing capture is a defect.
      write_concept(dir, "verified-capture.md",
        type: "source",
        id: "sb:cccccc",
        verified: true,
        resource: "https://example.org/x"
      )

      write_concept(dir, "bad-claim.md",
        type: "concept",
        id: "sb:dddddd",
        verified: true,
        verified_by: "[sb:ffffff]"
      )

      write_concept(dir, "ungrounded.md", type: "claim", id: "sb:eeeeee", verified: true)

      assert {:error, errors} = Verifier.run(dir)
      joined = Enum.join(errors, "\n")

      assert joined =~ "no-id.md: missing stable `id`"
      assert joined =~ "verified_by sb:ffffff does not resolve"
      assert joined =~ "verified-capture.md: verified: true but stores a link"
      assert joined =~ "ungrounded.md: verified: true but no evidence"
    end

    test "flags `verified` (either value) on a non-statement type", %{tmp_dir: dir} do
      write_concept(dir, "how-to.md", type: "methodology", id: "sb:abc123", verified: false)
      write_concept(dir, "captured.md", type: "reference", id: "sb:def456", verified: false)

      assert {:error, errors} = Verifier.run(dir)
      joined = Enum.join(errors, "\n")

      assert joined =~ "how-to.md: `verified` on type \"methodology\""
      assert joined =~ "captured.md: `verified` on type \"reference\""
      assert joined =~ "only for agent statements"
    end
  end
end
