defmodule SecondBrain.LinksTest do
  use ExUnit.Case, async: true

  alias SecondBrain.Links

  @moduletag :tmp_dir

  defp write(dir, rel_path, body) do
    path = Path.join(dir, rel_path)
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, body)
  end

  defp indexed(dir, rel_dir, listed) do
    write(
      dir,
      Path.join(rel_dir, "index.md"),
      "# index\n\n" <> Enum.map_join(listed, "\n", &"- #{&1}")
    )
  end

  # --- link resolution -------------------------------------------------------

  test "a bundle-absolute link that resolves is quiet; one that doesn't warns", %{tmp_dir: dir} do
    indexed(dir, ".", ["a.md", "b.md"])
    write(dir, "a.md", "see [b](/b.md) and [ghost](/missing.md)")
    write(dir, "b.md", "body")

    assert [warning] = Links.check(dir)
    assert warning =~ "a.md: link `/missing.md` does not resolve"
  end

  test "relative links resolve from the doc's own directory, including ..", %{tmp_dir: dir} do
    indexed(dir, ".", ["top.md", "sub"])
    indexed(dir, "sub", ["inner.md"])
    write(dir, "top.md", "body")
    write(dir, "sub/inner.md", "up: [top](../top.md), broken: [x](../nope.md)")

    assert [warning] = Links.check(dir)
    assert warning =~ "sub/inner.md: link `../nope.md` does not resolve"
  end

  test "external, mailto, anchor-only, placeholder, and fragment links are handled", %{
    tmp_dir: dir
  } do
    indexed(dir, ".", ["a.md", "b.md"])
    write(dir, "b.md", "# b\n## section")

    write(dir, "a.md", """
    [ext](https://example.com/x.md) [mail](mailto:x@y.z) [anchor](#here)
    [placeholder](/SWE/…/foo.md) [fragment ok](/b.md#section)
    """)

    assert Links.check(dir) == []
  end

  test "meta/threads bodies and excerpt-log sections are exempt", %{tmp_dir: dir} do
    indexed(dir, ".", ["c.md", "meta"])
    indexed(dir, "meta", ["threads"])
    indexed(dir, "meta/threads", ["2026-01-01-t.md"])
    write(dir, "meta/threads/2026-01-01-t.md", "frozen [broken](/gone.md)")

    write(dir, "c.md", """
    live body

    ## Thread excerpts — route-tagged log

    quoted frozen text with [broken](/also-gone.md)

    ## After

    [real](/meta/index.md)
    """)

    write(dir, "meta/index.md", "- threads")

    assert Links.check(dir) == []
  end

  test "links quoted in code spans and fenced blocks are literal text, not checked", %{
    tmp_dir: dir
  } do
    indexed(dir, ".", ["a.md"])

    write(dir, "a.md", """
    the old bug was `[OKF](/references/gone.md)` in the policy

    ```
    [example](/also/gone.md)
    ```
    """)

    assert Links.check(dir) == []
  end

  # --- index coverage --------------------------------------------------------

  test "a doc not mentioned in its directory's index warns", %{tmp_dir: dir} do
    indexed(dir, ".", ["listed.md"])
    write(dir, "listed.md", "body")
    write(dir, "orphan.md", "body")

    assert [warning] = Links.check(dir)
    assert warning =~ "index.md: orphan.md is filed here but not listed"
  end

  test "a directory holding docs without an index.md warns", %{tmp_dir: dir} do
    indexed(dir, ".", ["bare"])
    write(dir, "bare/doc.md", "body")

    assert Enum.any?(Links.check(dir), &(&1 =~ "bare: holds docs but has no index.md"))
  end

  test "an immediate subdirectory not mentioned in the parent index warns", %{tmp_dir: dir} do
    indexed(dir, ".", [])
    indexed(dir, "hidden", ["doc.md"])
    write(dir, "hidden/doc.md", "body")

    assert [warning] = Links.check(dir)
    assert warning =~ "index.md: subdirectory hidden/ is not listed"
  end

  test "reserved files need not be listed; excluded dirs are invisible", %{tmp_dir: dir} do
    indexed(dir, ".", [])

    write(
      dir,
      "README.md",
      "no [broken](/x.md) check here would still warn — but listing isn't required"
    )

    write(dir, "CLAUDE.md", "reserved")
    write(dir, "deprecated/old.md", "[dead](/gone.md)")
    write(dir, "lib/notes.md", "[dead](/gone.md)")

    warnings = Links.check(dir)
    refute Enum.any?(warnings, &(&1 =~ "README.md is filed here but not listed"))
    refute Enum.any?(warnings, &(&1 =~ "deprecated"))
    refute Enum.any?(warnings, &(&1 =~ "lib"))
    assert Enum.any?(warnings, &(&1 =~ "README.md: link `/x.md` does not resolve"))
  end
end
