defmodule ElixirMind.Markdown do
  @moduledoc """
  A small, dependency-free Markdown → HTML converter, scoped to the constructs the
  elixir-mind bundle actually uses: ATX headings (with GitHub-style slug anchors),
  bulleted and numbered lists (nested by indentation), fenced code blocks, inline
  code, GitHub-style tables, blockquotes, horizontal rules, paragraphs, and inline
  emphasis / links / autolinks.

  Staying dependency-free keeps the site generator in step with the rest of the
  tooling (`mix brain.*`), which parses the bundle with the standard library only
  so it runs offline in any sandbox.

  ## Link rewriting

  Bundle cross-links point at markdown files (`[x](/SWE/index.md)`,
  `[y](../foo.md)`). `to_html/2` rewrites those to the generated `.html` pages,
  resolving relative paths against the source file's directory and prefixing the
  result so the link works from the page's depth in the output tree. External URLs,
  `mailto:`, and pure `#anchor` links pass through untouched.
  """

  @doc """
  Render a markdown `body` to an HTML fragment.

  `opts`:

    * `:dir` — the source document's directory, bundle-root-relative (e.g.
      `"SWE/agentic-coding"`). Used to resolve relative `.md` links. Defaults to `""`.
    * `:root_prefix` — the relative path from the page back to the output root
      (e.g. `"../../"`). Prepended to rewritten internal links. Defaults to `""`.
  """
  @spec to_html(binary, keyword) :: binary
  def to_html(body, opts \\ []) when is_binary(body) do
    ctx = %{
      dir: Keyword.get(opts, :dir, ""),
      root_prefix: Keyword.get(opts, :root_prefix, "")
    }

    body
    |> String.replace("\r\n", "\n")
    |> String.split("\n")
    |> parse_blocks([], ctx)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  @doc """
  Slugify a heading the way GitHub does: downcase, drop punctuation other than
  spaces and hyphens, then turn spaces into hyphens. Used for in-page `#anchor`
  targets so bundle links like `[x](#grounding)` resolve.
  """
  @spec slug(binary) :: binary
  def slug(text) do
    text
    |> String.downcase()
    |> String.replace(~r/[^\w\s-]/u, "")
    |> String.trim()
    |> String.replace(~r/\s+/u, "-")
  end

  # --- block parser --------------------------------------------------------

  defp parse_blocks([], acc, _ctx), do: acc

  defp parse_blocks([line | rest], acc, ctx) do
    trimmed = String.trim(line)

    cond do
      trimmed == "" ->
        parse_blocks(rest, acc, ctx)

      fence?(trimmed) ->
        {html, rest} = take_code_fence(trimmed, rest)
        parse_blocks(rest, [html | acc], ctx)

      comment_open?(trimmed) ->
        rest = skip_comment(trimmed, rest)
        parse_blocks(rest, acc, ctx)

      heading?(trimmed) ->
        parse_blocks(rest, [heading(trimmed, ctx) | acc], ctx)

      hr?(trimmed) ->
        parse_blocks(rest, ["<hr />" | acc], ctx)

      table_start?(line, rest) ->
        {html, rest} = take_table([line | rest], ctx)
        parse_blocks(rest, [html | acc], ctx)

      blockquote?(trimmed) ->
        {html, rest} = take_blockquote([line | rest], ctx)
        parse_blocks(rest, [html | acc], ctx)

      list_item?(line) ->
        {html, rest} = take_list([line | rest], ctx)
        parse_blocks(rest, [html | acc], ctx)

      true ->
        {html, rest} = take_paragraph([line | rest], ctx)
        parse_blocks(rest, [html | acc], ctx)
    end
  end

  # --- fenced code blocks --------------------------------------------------

  defp fence?(line), do: String.starts_with?(line, "```") or String.starts_with?(line, "~~~")

  defp take_code_fence(open, lines) do
    marker = String.slice(open, 0, 3)
    lang = open |> String.slice(3..-1//1) |> String.trim()

    {code_lines, rest} =
      Enum.split_while(lines, &(not String.starts_with?(String.trim(&1), marker)))

    rest = Enum.drop(rest, 1)

    class = if lang == "", do: "", else: ~s( class="language-#{escape(lang)}")
    code = code_lines |> Enum.map_join("\n", &escape/1)
    {"<pre><code#{class}>#{code}</code></pre>", rest}
  end

  # --- HTML comments -------------------------------------------------------

  defp comment_open?(line), do: String.starts_with?(line, "<!--")

  defp skip_comment(line, rest) do
    if String.contains?(line, "-->") do
      rest
    else
      rest
      |> Enum.drop_while(&(not String.contains?(&1, "-->")))
      |> Enum.drop(1)
    end
  end

  # --- headings ------------------------------------------------------------

  defp heading?(line), do: Regex.match?(~r/^\#{1,6}\s+/, line)

  defp heading(line, ctx) do
    [hashes, text] = Regex.run(~r/^(\#{1,6})\s+(.*)$/, line, capture: :all_but_first)
    level = String.length(hashes)
    # Drop an optional closing run of hashes (ATX "## foo ##").
    text = text |> String.replace(~r/\s+#+\s*$/, "") |> String.trim()
    id = slug(text)
    inner = inline(text, ctx)

    ~s(<h#{level} id="#{id}"><a class="anchor" href="##{id}" aria-hidden="true">#</a>#{inner}</h#{level}>)
  end

  # --- horizontal rule -----------------------------------------------------

  defp hr?(line), do: line in ["---", "***", "___", "- - -", "* * *"]

  # --- tables --------------------------------------------------------------

  defp table_start?(line, rest) do
    String.contains?(line, "|") and
      case rest do
        [sep | _] -> table_separator?(sep)
        _ -> false
      end
  end

  defp table_separator?(line) do
    line = String.trim(line)
    line =~ ~r/^\|?[\s:|-]+\|[\s:|-]*$/ and String.contains?(line, "-")
  end

  defp take_table([header, sep | rest], ctx) do
    {rows, rest} = Enum.split_while(rest, &(String.trim(&1) != "" and String.contains?(&1, "|")))

    aligns = sep |> row_cells() |> Enum.map(&alignment/1)
    head = header |> cells_with_aligns(aligns) |> Enum.map_join("", &cell("th", &1, ctx))

    body =
      Enum.map_join(rows, "", fn row ->
        cells = row |> cells_with_aligns(aligns) |> Enum.map_join("", &cell("td", &1, ctx))
        "<tr>#{cells}</tr>"
      end)

    html =
      "<div class=\"table-wrap\"><table><thead><tr>#{head}</tr></thead><tbody>#{body}</tbody></table></div>"

    {html, rest}
  end

  # GitHub-style column alignment from the separator row's `:` markers.
  defp alignment(spec) do
    case {String.starts_with?(spec, ":"), String.ends_with?(spec, ":")} do
      {true, true} -> "center"
      {false, true} -> "right"
      {true, false} -> "left"
      _ -> nil
    end
  end

  defp cells_with_aligns(row, aligns) do
    Enum.zip(row_cells(row), Stream.concat(aligns, Stream.cycle([nil])))
  end

  defp cell(tag, {text, nil}, ctx), do: "<#{tag}>#{inline(text, ctx)}</#{tag}>"

  defp cell(tag, {text, align}, ctx),
    do: ~s(<#{tag} style="text-align:#{align}">#{inline(text, ctx)}</#{tag}>)

  defp row_cells(row) do
    row
    |> String.trim()
    |> String.trim_leading("|")
    |> String.trim_trailing("|")
    |> String.split("|")
    |> Enum.map(&String.trim/1)
  end

  # --- blockquotes ---------------------------------------------------------

  defp blockquote?(line), do: line == ">" or String.starts_with?(line, "> ")

  defp take_blockquote(lines, ctx) do
    {quoted, rest} = Enum.split_while(lines, &blockquote?(String.trim(&1)))

    inner =
      quoted
      |> Enum.map_join("\n", fn line ->
        line |> String.trim() |> String.replace_prefix(">", "") |> String.trim_leading()
      end)

    {"<blockquote>#{to_html(inner, dir: ctx.dir, root_prefix: ctx.root_prefix)}</blockquote>",
     rest}
  end

  # --- lists (nested by indentation) --------------------------------------

  defp list_item?(line) do
    Regex.match?(~r/^\s*[-*+]\s+/, line) or Regex.match?(~r/^\s*\d+\.\s+/, line)
  end

  defp take_list(lines, ctx) do
    {list_lines, rest} = Enum.split_while(lines, &(list_item?(&1) or continuation?(&1)))
    {render_list(list_lines, ctx), rest}
  end

  defp continuation?(line), do: line != "" and String.match?(line, ~r/^\s+\S/)

  # Build HTML for a list given its raw lines. Groups items at the shallowest
  # indent, recursing on more-indented blocks that belong to each item.
  defp render_list(lines, ctx) do
    base_indent = lines |> Enum.filter(&list_item?/1) |> Enum.map(&indent_of/1) |> Enum.min()
    ordered = lines |> Enum.find(&list_item?/1) |> ordered?()

    items =
      lines
      |> chunk_items(base_indent)
      |> Enum.map(&render_item(&1, base_indent, ctx))

    tag = if ordered, do: "ol", else: "ul"
    "<#{tag}>" <> Enum.join(items, "") <> "</#{tag}>"
  end

  # Split lines into one chunk per top-level item at `base_indent`.
  defp chunk_items(lines, base_indent) do
    lines
    |> Enum.reduce([], fn line, acc ->
      if list_item?(line) and indent_of(line) == base_indent do
        [[line] | acc]
      else
        case acc do
          [current | tail] -> [[line | current] | tail]
          [] -> [[line]]
        end
      end
    end)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reverse()
  end

  defp render_item([first | nested], base_indent, ctx) do
    text = strip_marker(first)

    {own, deeper} =
      Enum.split_while(nested, fn line ->
        not (list_item?(line) and indent_of(line) <= base_indent)
      end)

    # Continuation lines that are more indented than this item's marker but not
    # themselves list items are folded into the item's text.
    {sub_list, extra_text} = Enum.split_with(own, &list_item?/1)

    text =
      [text | Enum.map(extra_text, &String.trim/1)]
      |> Enum.reject(&(&1 == ""))
      |> Enum.join(" ")

    inner = inline(text, ctx)

    nested_html =
      case sub_list ++ deeper do
        [] -> ""
        sub -> render_list(sub, ctx)
      end

    "<li>#{inner}#{nested_html}</li>"
  end

  defp ordered?(nil), do: false
  defp ordered?(line), do: Regex.match?(~r/^\s*\d+\.\s+/, line)

  defp indent_of(line) do
    [ws] = Regex.run(~r/^\s*/, line)
    String.length(ws)
  end

  defp strip_marker(line) do
    line
    |> String.replace(~r/^\s*[-*+]\s+/, "")
    |> String.replace(~r/^\s*\d+\.\s+/, "")
  end

  # --- paragraphs ----------------------------------------------------------

  defp take_paragraph(lines, ctx) do
    {para, rest} =
      Enum.split_while(lines, fn line ->
        t = String.trim(line)

        t != "" and not heading?(t) and not fence?(t) and not list_item?(line) and
          not blockquote?(t) and not hr?(t) and not comment_open?(t) and
          not table_start?(line, tl_or_empty(lines, line))
      end)

    text = para |> Enum.map_join(" ", &String.trim/1)
    {"<p>#{inline(text, ctx)}</p>", rest}
  end

  # table_start? needs the *following* lines; within a paragraph scan we only
  # need to know whether the current line begins a table, so peek conservatively.
  defp tl_or_empty(lines, line) do
    case Enum.drop_while(lines, &(&1 != line)) do
      [_ | rest] -> rest
      _ -> []
    end
  end

  # --- inline --------------------------------------------------------------

  @sep "\x00"

  @doc false
  def inline(text, ctx) do
    # Both code spans and links are lifted out to opaque placeholders before any
    # escaping/emphasis runs, then restored last. This lets emphasis span across
    # a code span (e.g. **`git fetch`**) while the code span's own contents are
    # never treated as markdown. Code spans come first, so link syntax written
    # inside inline code (e.g. `[x](/path.md)`) stays literal; a link label may
    # still contain a code span (e.g. [`sources/`](/path)) because the label's
    # code placeholder survives link extraction and is restored last.
    {text, codes} = extract_code(text)
    {text, links} = extract_links(text, ctx)

    text
    |> escape()
    |> autolinks()
    |> emphasis()
    |> restore(links)
    |> restore(codes)
  end

  # Replace every [label](href) with a placeholder, remembering the rendered
  # anchor (label recursively inline-processed, href rewritten).
  defp extract_links(text, ctx) do
    Regex.scan(~r/\[([^\]]*)\]\(([^)\s]+)\)/, text)
    |> Enum.with_index()
    |> Enum.reduce({text, []}, fn {[full, label, href], i}, {acc, map} ->
      token = @sep <> "L#{i}" <> @sep
      # Escape the rewritten href: links are lifted out before the document-wide
      # escape pass, so an unescaped URL containing `"` would break out of the
      # attribute (and `&` would be invalid HTML). Escaping here keeps the anchor
      # opaque to markdown while still being safe HTML.
      anchor = ~s(<a href="#{escape(rewrite_href(href, ctx))}">#{inline(label, ctx)}</a>)
      {String.replace(acc, full, token, global: false), [{token, anchor} | map]}
    end)
  end

  # Replace every `code span` with a placeholder mapped to its rendered <code>.
  # An unbalanced backtick count means the final opener never closed; leave the
  # text untouched in that case rather than eating content.
  defp extract_code(text) do
    parts = String.split(text, "`")

    if rem(length(parts), 2) == 0 do
      {text, []}
    else
      parts
      |> Enum.with_index()
      |> Enum.reduce({"", []}, fn {part, i}, {acc, map} ->
        if rem(i, 2) == 0 do
          {acc <> part, map}
        else
          token = @sep <> "C#{i}" <> @sep
          {acc <> token, [{token, "<code>#{escape(part)}</code>"} | map]}
        end
      end)
    end
  end

  defp restore(text, replacements) do
    Enum.reduce(replacements, text, fn {token, html}, acc ->
      String.replace(acc, token, html)
    end)
  end

  # <https://...> autolinks. `<` / `>` were escaped, so match the escaped form.
  defp autolinks(text) do
    Regex.replace(~r/&lt;((?:https?|mailto):[^\s]+?)&gt;/, text, fn _full, url ->
      ~s(<a href="#{url}">#{url}</a>)
    end)
  end

  # Bold first, non-greedy over any content, so it can wrap an inner italic
  # (**bold *and italic* here**); italic then runs on the result.
  defp emphasis(text) do
    text
    |> then(&Regex.replace(~r/\*\*(.+?)\*\*/, &1, "<strong>\\1</strong>"))
    |> then(&Regex.replace(~r/__(.+?)__/, &1, "<strong>\\1</strong>"))
    |> then(&Regex.replace(~r/(?<![\*\w])\*([^*\s][^*]*?)\*(?!\w)/, &1, "<em>\\1</em>"))
    |> then(&Regex.replace(~r/(?<![_\w])_([^_\s][^_]*?)_(?!\w)/, &1, "<em>\\1</em>"))
  end

  # --- href rewriting ------------------------------------------------------

  @doc false
  def rewrite_href(href, ctx) do
    cond do
      href =~ ~r{^[a-z][a-z0-9+.-]*://}i -> href
      String.starts_with?(href, "mailto:") -> href
      String.starts_with?(href, "#") -> href
      true -> rewrite_internal(href, ctx)
    end
  end

  defp rewrite_internal(href, ctx) do
    {path, frag} =
      case String.split(href, "#", parts: 2) do
        [p, f] -> {p, "#" <> f}
        [p] -> {p, ""}
      end

    if path == "" do
      frag
    else
      root_rel =
        if String.starts_with?(path, "/") do
          String.trim_leading(path, "/")
        else
          normalize(join_path(ctx.dir, path))
        end

      root_rel = if String.ends_with?(root_rel, ".md"), do: mdswap(root_rel), else: root_rel
      ctx.root_prefix <> root_rel <> frag
    end
  end

  defp mdswap(path), do: String.replace_suffix(path, ".md", ".html")

  defp join_path("", path), do: path
  defp join_path(dir, path), do: dir <> "/" <> path

  # Resolve "." and ".." segments without touching the filesystem.
  defp normalize(path) do
    path
    |> String.split("/")
    |> Enum.reduce([], fn
      ".", acc -> acc
      "", acc -> acc
      "..", [_ | rest] -> rest
      "..", [] -> []
      seg, acc -> [seg | acc]
    end)
    |> Enum.reverse()
    |> Enum.join("/")
  end

  # --- escaping ------------------------------------------------------------

  @doc false
  def escape(text) do
    text
    |> String.replace("&", "&amp;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("\"", "&quot;")
  end
end
