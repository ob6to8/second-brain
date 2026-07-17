defmodule ElixirMind.OrphansTest do
  use ExUnit.Case, async: true

  alias ElixirMind.Orphans

  @moduletag :tmp_dir

  defp write(dir, rel_path, body) do
    path = Path.join(dir, rel_path)
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, body)
  end

  test "a doc nothing links to is an orphan; a linked one is not", %{tmp_dir: dir} do
    write(dir, "index.md", "- [a](/a.md)\n- [b](/b.md)")
    write(dir, "a.md", "see [b](/b.md)")
    write(dir, "b.md", "body")

    # b is linked from a; a is linked from nothing but the index (ignored) -> orphan
    assert Orphans.find(dir) == ["a.md"]
  end

  test "index.md listings don't count unless include_index is set", %{tmp_dir: dir} do
    write(dir, "index.md", "- [a](/a.md)")
    write(dir, "a.md", "body")

    assert Orphans.find(dir) == ["a.md"]
    assert Orphans.find(dir, include_index: true) == []
  end

  test "relative and bundle-absolute inbound links both resolve", %{tmp_dir: dir} do
    write(dir, "index.md", "- [top](/top.md)\n- [sub](/sub/index.md)")
    write(dir, "sub/index.md", "- [inner](/sub/inner.md)")
    write(dir, "top.md", "down: [inner](sub/inner.md)")
    write(dir, "sub/inner.md", "up: [top](../top.md)")

    assert Orphans.find(dir) == []
  end

  test "anchored namespaces are excluded from candidates unless --all", %{tmp_dir: dir} do
    write(dir, "index.md", "- [a](/a.md)")
    write(dir, "a.md", "body")
    write(dir, "meta/threads/2026-01-01-t.md", "a thread nothing links to")
    write(dir, "inbox/2026-01-01.md", "a digest nothing links to")

    assert Orphans.find(dir) == ["a.md"]

    assert Orphans.find(dir, all: true) ==
             ["a.md", "inbox/2026-01-01.md", "meta/threads/2026-01-01-t.md"]
  end

  test "reserved files are never reported as orphans", %{tmp_dir: dir} do
    write(dir, "index.md", "nothing linked")
    write(dir, "README.md", "readme")
    write(dir, "CLAUDE.md", "contract")

    assert Orphans.find(dir) == []
  end
end
