defmodule ElixirMind.CodeMapTest do
  use ExUnit.Case, async: false

  alias ElixirMind.CodeMap

  test "modules splits ElixirMind.* from the mix tasks and drops hidden moduledocs" do
    {library, tasks} = CodeMap.modules()
    lib_mods = Enum.map(library, fn {m, _} -> m end)
    task_mods = Enum.map(tasks, fn {m, _} -> m end)

    assert ElixirMind.Registry in lib_mods
    assert Mix.Tasks.Brain.Codemap in task_mods

    # No mix task leaks into the library group and vice versa.
    refute Enum.any?(lib_mods, &match?(["Mix", "Tasks" | _], Module.split(&1)))
    assert Enum.all?(task_mods, &match?(["Mix", "Tasks", "Brain", _], Module.split(&1)))

    # `@moduledoc false` internals (e.g. the Registry.Entry struct) are omitted.
    refute ElixirMind.Registry.Entry in lib_mods
    refute ElixirMind.Registry.Entry in task_mods
  end

  test "render carries the banner, both sections, and real module + function intent" do
    out = CodeMap.render()

    assert out =~ "GENERATED FILE — do not edit by hand"
    assert out =~ "# Code map — module, function & type intent"
    assert out =~ "## Library — `ElixirMind.*`"
    assert out =~ "## Mix tasks — `mix brain.*`"

    # A known module renders its heading, source path, moduledoc, and a documented function.
    assert out =~ "### `ElixirMind.Registry`"
    assert out =~ "`lib/elixir_mind/registry.ex`"
    assert out =~ "stable-identity layer"
    assert out =~ "- `mint/1` — Mint a fresh stable id"

    # An undocumented function is listed bare (no em-dash summary).
    assert out =~ ~r/- `channels\/0`\n/
  end

  test "every documented module renders an existing lib/ source path" do
    out = CodeMap.render()
    {library, tasks} = CodeMap.modules()

    for {mod, _} <- library ++ tasks do
      path = mod.module_info(:compile)[:source] |> to_string() |> Path.relative_to(File.cwd!())

      assert String.starts_with?(path, "lib/"), "#{inspect(mod)} → unexpected path #{path}"
      assert File.exists?(path), "#{inspect(mod)} → #{path} does not exist"
      assert out =~ "`#{path}`"
    end
  end

  @tag :tmp_dir
  test "write/check round-trips and detects staleness", %{tmp_dir: dir} do
    File.mkdir_p!(Path.join(dir, "meta"))

    path = CodeMap.write(dir)
    assert path == Path.join(dir, "meta/code-map.md")
    assert CodeMap.check(dir) == :ok

    File.write!(path, "hand-edited\n")
    assert {:stale, "meta/code-map.md"} = CodeMap.check(dir)
  end
end
