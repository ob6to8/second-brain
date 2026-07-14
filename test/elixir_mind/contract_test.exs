defmodule ElixirMind.ContractTest do
  use ExUnit.Case, async: false

  alias ElixirMind.{Contract, Policy}

  @moduletag :tmp_dir

  setup %{tmp_dir: dir} do
    File.mkdir_p!(Path.join(dir, "meta/policy"))
    File.write!(Path.join(dir, "meta/preamble.md"), "# Contract\n\nIntro prose.")
    :ok
  end

  defp write_policy(dir, id, fields, body) do
    fm = Enum.map_join(fields, "\n", fn {k, v} -> "#{k}: #{v}" end)
    File.write!(Path.join(dir, "meta/policy/#{id}.md"), "---\n#{fm}\n---\n#{body}\n")
  end

  test "renders policies grouped by section, ordered, with trace links and banner", %{
    tmp_dir: dir
  } do
    write_policy(
      dir,
      "b-rule",
      [type: "policy", title: "B", section: "filing", order: 2],
      "Rule B body."
    )

    write_policy(
      dir,
      "a-rule",
      [type: "policy", title: "A", section: "filing", order: 1],
      "Rule A body."
    )

    out = Contract.render(dir)

    assert String.starts_with?(out, "<!--")
    assert out =~ "GENERATED FILE"
    assert out =~ "Intro prose."
    assert out =~ "## 3. Filing conventions"
    # order: a-rule (1) before b-rule (2)
    assert :binary.match(out, "Rule A body.") < :binary.match(out, "Rule B body.")
    assert out =~ "_Source: [`meta/policy/a-rule.md`](/meta/policy/a-rule.md)_"
  end

  test "check/1 reports :ok after write and :stale after drift", %{tmp_dir: dir} do
    write_policy(
      dir,
      "a-rule",
      [type: "policy", title: "A", section: "filing", order: 1],
      "Rule A body."
    )

    Contract.write(dir)
    assert Contract.check(dir) == :ok

    File.write!(Path.join(dir, Contract.output_path()), "tampered\n")
    assert {:stale, _summary} = Contract.check(dir)
  end

  test "raises on unknown section", %{tmp_dir: dir} do
    write_policy(dir, "bad", [type: "policy", title: "Bad", section: "nope", order: 1], "x")
    assert_raise ArgumentError, ~r/unknown contract section/, fn -> Contract.render(dir) end
  end

  test "Policy.load! rejects non-policy type", %{tmp_dir: dir} do
    write_policy(dir, "note", [type: "note", title: "N", section: "filing", order: 1], "x")

    assert_raise ArgumentError, ~r/expected `type: policy`/, fn ->
      Policy.load!(Path.join(dir, "meta/policy/note.md"))
    end
  end
end
