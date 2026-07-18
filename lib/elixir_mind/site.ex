defmodule ElixirMind.Site do
  @moduledoc """
  Static-site generator for the knowledge bundle.

  Renders the OKF bundle into a self-contained, navigable HTML site suitable for
  GitHub Pages: one page per concept (and per `index.md`/`log.md`/doc), a sidebar
  that mirrors the directory taxonomy, per-concept metadata panels (type, tags,
  verification, evidence edges and their reverse), and a client-side search index.

  Like the other `mix brain.*` tools it is **dependency-free** — it reuses
  `ElixirMind.Frontmatter` and `ElixirMind.Markdown` and the standard library
  only, so `mix brain.site` runs offline in CI and any sandbox.

  All internal links are **relative** (each page carries a `root_prefix` computed
  from its depth), so the site works both at a domain root and under a project
  subpath like `/elixir-mind/` without configuration.
  """

  alias ElixirMind.{Frontmatter, Markdown, SiteConfig}

  @default_out "_site"

  @type page :: %{
          src: String.t(),
          out: String.t(),
          dir: String.t(),
          depth: non_neg_integer,
          root_prefix: String.t(),
          fm: map,
          body: String.t(),
          title: String.t(),
          type: String.t() | nil,
          kind: atom
        }

  @doc "Default output directory (relative to repo root)."
  def default_out, do: @default_out

  @doc """
  Build the site from `root` into `out_dir`. Removes and recreates `out_dir`,
  then writes every page plus `assets/` and `search-index.json`. Returns the
  number of pages written.
  """
  @spec build(String.t(), String.t()) :: non_neg_integer
  def build(root \\ File.cwd!(), out_dir \\ @default_out) do
    out = Path.expand(out_dir, root)
    File.rm_rf!(out)
    File.mkdir_p!(out)

    pages = load_pages(root)
    id_index = build_id_index(pages)
    backlinks = build_backlinks(pages)
    tree = build_tree(pages)

    Enum.each(pages, fn page ->
      html = render_page(page, tree, id_index, backlinks)
      dest = Path.join(out, page.out)
      File.mkdir_p!(Path.dirname(dest))
      File.write!(dest, html)
    end)

    File.mkdir_p!(Path.join(out, "assets"))
    File.write!(Path.join(out, "assets/style.css"), css())
    File.write!(Path.join(out, "assets/app.js"), app_js())
    File.write!(Path.join(out, "search-index.json"), search_index(pages))
    # Tell GitHub Pages to serve our HTML as-is (no Jekyll processing).
    File.write!(Path.join(out, ".nojekyll"), "")

    length(pages)
  end

  # --- loading -------------------------------------------------------------

  defp load_pages(root) do
    root
    |> Path.join("**/*.md")
    |> Path.wildcard()
    |> Enum.map(&Path.relative_to(&1, root))
    |> Enum.reject(&excluded?/1)
    |> Enum.sort()
    |> Enum.map(&load_page(&1, root))
  end

  defp excluded?(rel_path) do
    [top | _] = Path.split(rel_path)
    top in SiteConfig.excluded_dirs()
  end

  defp load_page(src, root) do
    raw = root |> Path.join(src) |> File.read!()

    {fm, body} =
      case Frontmatter.parse(raw) do
        {:ok, %{frontmatter: fm, body: body}} -> {fm, body}
        {:error, _} -> {%{}, raw}
      end

    body = SiteConfig.expand_tokens(body)
    out = String.replace_suffix(src, ".md", ".html")
    dir = dir_of(src)
    depth = out |> Path.split() |> length() |> Kernel.-(1)

    %{
      src: src,
      out: out,
      dir: dir,
      depth: depth,
      root_prefix: String.duplicate("../", depth),
      fm: fm,
      body: body,
      title: title_for(src, fm, body),
      type: fm["type"],
      kind: kind_for(src, fm)
    }
  end

  defp dir_of(src) do
    case Path.dirname(src) do
      "." -> ""
      d -> d
    end
  end

  defp kind_for("index.md", _fm), do: :root

  defp kind_for(src, fm) do
    base = Path.basename(src)

    cond do
      base == "index.md" -> :index
      base == "log.md" -> :log
      is_binary(fm["id"]) or is_binary(fm["type"]) -> :concept
      true -> :doc
    end
  end

  defp title_for(src, fm, body) do
    cond do
      is_binary(fm["title"]) and fm["title"] != "" -> fm["title"]
      src == "index.md" -> "Elixir Mind"
      (h1 = first_h1(body)) != nil -> h1
      Path.basename(src) == "index.md" -> humanize(Path.basename(dir_of(src)))
      true -> humanize(Path.basename(src, ".md"))
    end
  end

  defp first_h1(body) do
    body
    |> String.split("\n")
    |> Enum.find_value(fn line ->
      case Regex.run(~r/^#\s+(.*)$/, String.trim(line)) do
        [_, text] -> String.trim(text)
        _ -> nil
      end
    end)
  end

  defp humanize(""), do: "Home"

  defp humanize(slug) do
    slug
    |> String.replace(["-", "_"], " ")
    |> String.split()
    |> Enum.map_join(" ", &:string.titlecase/1)
  end

  # --- indexes -------------------------------------------------------------

  defp build_id_index(pages) do
    for %{fm: %{"id" => id}} = p <- pages, is_binary(id), into: %{}, do: {id, p}
  end

  # Reverse `verified_by` edges: id => [pages that cite it as evidence].
  defp build_backlinks(pages) do
    pages
    |> Enum.flat_map(fn p ->
      p.fm["verified_by"] |> List.wrap() |> Enum.map(&{&1, p})
    end)
    |> Enum.group_by(fn {id, _} -> id end, fn {_, p} -> p end)
  end

  # --- navigation tree -----------------------------------------------------

  # A node: %{name, dir, index: page|nil, dirs: [node], files: [page]}.
  defp build_tree(pages) do
    by_dir = Enum.group_by(pages, & &1.dir)
    all_dirs = pages |> Enum.flat_map(&ancestors(&1.dir)) |> Enum.uniq()
    build_node("", by_dir, all_dirs)
  end

  defp ancestors(""), do: [""]

  defp ancestors(dir) do
    dir
    |> Path.split()
    |> Enum.scan(&Path.join(&2, &1))
    |> then(&["" | &1])
  end

  defp build_node(dir, by_dir, all_dirs) do
    here = Map.get(by_dir, dir, [])
    index = Enum.find(here, &(Path.basename(&1.src) == "index.md"))

    files =
      here
      |> Enum.reject(&(Path.basename(&1.src) == "index.md"))
      |> Enum.sort_by(&{&1.kind == :log, String.downcase(&1.title)})

    child_dirs =
      all_dirs
      |> Enum.filter(&(&1 != dir and Path.dirname(&1) == if(dir == "", do: ".", else: dir)))
      |> Enum.sort()
      |> Enum.map(&build_node(&1, by_dir, all_dirs))

    %{
      name: if(dir == "", do: "Elixir Mind", else: humanize(Path.basename(dir))),
      dir: dir,
      index: index,
      dirs: child_dirs,
      files: files
    }
  end

  # --- per-page rendering --------------------------------------------------

  defp render_page(page, tree, id_index, backlinks) do
    p = page.root_prefix

    """
    <!doctype html>
    <html lang="en">
    <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>#{esc(page.title)} · Elixir Mind</title>
    #{description_meta(page)}
    <link rel="stylesheet" href="#{p}assets/style.css" />
    <script>window.SB_ROOT=#{json_string(p)};</script>
    </head>
    <body>
    <a class="skip-link" href="#main">Skip to content</a>
    <header class="topbar">
      <button class="icon-btn nav-toggle" aria-label="Toggle navigation" aria-expanded="false">☰</button>
      <a class="brand" href="#{p}index.html"><span class="brand-mark">🧠</span> Elixir Mind</a>
      <div class="search" role="search">
        <input id="search-input" type="search" placeholder="Search the brain…  (press /)" autocomplete="off" aria-label="Search" />
        <div id="search-results" class="search-results" hidden></div>
      </div>
      <button class="icon-btn theme-toggle" aria-label="Toggle color theme" title="Toggle theme">◐</button>
    </header>
    <div class="layout">
      <aside class="sidebar" id="sidebar">
        <nav class="nav" aria-label="Knowledge base">
        #{render_nav(tree, page)}
        </nav>
      </aside>
      <div class="sidebar-scrim" id="sidebar-scrim" hidden></div>
      <main id="main" class="content">
        #{breadcrumbs(page, tree)}
        <article class="concept">
          #{page_header(page)}
          #{Markdown.to_html(strip_leading_h1(page), dir: page.dir, root_prefix: page.root_prefix)}
        </article>
        #{metadata_panel(page, id_index, backlinks)}
      </main>
    </div>
    <script src="#{p}assets/app.js"></script>
    </body>
    </html>
    """
  end

  defp description_meta(page) do
    case page.fm["description"] do
      d when is_binary(d) and d != "" -> ~s(<meta name="description" content="#{esc(d)}" />)
      _ -> ""
    end
  end

  # Render a consistent styled header for every page: the type badge (concepts),
  # the title, and the one-line description as a lede. The body's own leading `#
  # Title` is stripped (see strip_leading_h1/1) so it isn't shown twice.
  defp page_header(page) do
    badge =
      if page.type, do: ~s(<div class="header-meta">#{type_badge(page.type)}</div>), else: ""

    heading = ~s(<h1 class="page-title">#{esc(page.title)}</h1>)

    desc =
      case page.fm["description"] do
        d when is_binary(d) and d != "" ->
          ~s(<p class="lede">#{Markdown.inline(d, ctx(page))}</p>)

        _ ->
          ""
      end

    ~s(<header class="page-header">#{badge}#{heading}#{desc}</header>)
  end

  # Drop the body's first H1 line (surfaced instead as the styled page title).
  defp strip_leading_h1(page) do
    if body_has_h1?(page.body) do
      lines = String.split(page.body, "\n")
      idx = Enum.find_index(lines, &Regex.match?(~r/^#\s+/, String.trim(&1)))
      lines |> List.delete_at(idx) |> Enum.join("\n")
    else
      page.body
    end
  end

  defp body_has_h1?(body) do
    body
    |> String.split("\n")
    |> Enum.find(&(String.trim(&1) != ""))
    |> case do
      nil -> false
      line -> Regex.match?(~r/^#\s+/, String.trim(line))
    end
  end

  # --- breadcrumbs ---------------------------------------------------------

  defp breadcrumbs(%{src: "index.md"}, _tree), do: ""

  defp breadcrumbs(page, _tree) do
    p = page.root_prefix
    crumbs = [~s(<a href="#{p}index.html">Home</a>)]

    dir_crumbs =
      page.dir
      |> case do
        "" -> []
        dir -> Path.split(dir)
      end
      |> Enum.scan(&Path.join(&2, &1))
      |> Enum.map(fn dir ->
        rel = p <> dir <> "/index.html"
        ~s(<a href="#{rel}">#{esc(humanize(Path.basename(dir)))}</a>)
      end)

    current = ~s(<span aria-current="page">#{esc(page.title)}</span>)
    all = (crumbs ++ dir_crumbs ++ [current]) |> Enum.join(~s( <span class="sep">/</span> ))
    ~s(<nav class="breadcrumbs" aria-label="Breadcrumb">#{all}</nav>)
  end

  # --- navigation rendering ------------------------------------------------

  defp render_nav(root_node, page) do
    top_files = Enum.map_join(root_node.files, "", &nav_file(&1, page))
    top_dirs = Enum.map_join(root_node.dirs, "", &nav_dir(&1, page))
    ~s(<ul class="nav-list">#{top_dirs}#{top_files}</ul>)
  end

  defp nav_dir(node, page) do
    open? = within?(page, node.dir)
    open_attr = if open?, do: " open", else: ""

    label =
      case node.index do
        nil ->
          ~s(<span class="nav-dir-label">#{esc(node.name)}</span>)

        idx ->
          ~s(<a class="nav-dir-label#{active(idx, page)}" href="#{href(page, idx)}">#{esc(node.name)}</a>)
      end

    children =
      Enum.map_join(node.dirs, "", &nav_dir(&1, page)) <>
        Enum.map_join(node.files, "", &nav_file(&1, page))

    """
    <li class="nav-dir">
      <details#{open_attr}>
        <summary>#{label}</summary>
        <ul class="nav-list">#{children}</ul>
      </details>
    </li>
    """
  end

  defp nav_file(page_entry, page) do
    ~s(<li class="nav-file"><a class="#{String.trim("nav-link" <> active(page_entry, page))}" href="#{href(page, page_entry)}">#{esc(page_entry.title)}#{type_dot(page_entry.type)}</a></li>)
  end

  defp type_dot(nil), do: ""

  defp type_dot(type),
    do: ~s(<span class="type-dot type-#{esc(type)}" title="#{esc(type)}"></span>)

  defp active(target, current) do
    if target.out == current.out, do: " active", else: ""
  end

  # Is the current page inside directory `dir` (or its index)?
  defp within?(_page, ""), do: true
  defp within?(page, dir), do: page.dir == dir or String.starts_with?(page.dir <> "/", dir <> "/")

  defp href(from, to), do: from.root_prefix <> to.out

  # --- metadata panel ------------------------------------------------------

  defp metadata_panel(page, id_index, backlinks) do
    rows =
      [
        meta_row("Type", type_badge_or_nil(page.type)),
        meta_row("Verified", verified_row(page.fm)),
        meta_row("Resource", resource_row(page.fm)),
        meta_row("Provenance", text_row(page.fm["provenance"])),
        meta_row("Updated", text_row(stringify(page.fm["timestamp"]))),
        meta_row("ID", id_row(page.fm["id"])),
        meta_row("Tags", tags_row(page)),
        meta_row("Evidence", edges_row(page.fm["verified_by"], page, id_index)),
        meta_row("Cited by", cited_by_row(page.fm["id"], page, backlinks))
      ]
      |> Enum.reject(&is_nil/1)

    case rows do
      [] ->
        ""

      rows ->
        ~s(<aside class="meta-panel" aria-label="Metadata"><h2>Metadata</h2><dl>#{Enum.join(rows, "")}</dl></aside>)
    end
  end

  defp meta_row(_label, nil), do: nil

  defp meta_row(label, value),
    do: ~s(<div class="meta-item"><dt>#{label}</dt><dd>#{value}</dd></div>)

  defp type_badge_or_nil(nil), do: nil
  defp type_badge_or_nil(type), do: type_badge(type)

  defp type_badge(type), do: ~s(<span class="badge type-#{esc(type)}">#{esc(type)}</span>)

  defp verified_row(fm) do
    case fm["verified"] do
      true -> ~s(<span class="verified yes">✓ verified</span>)
      false -> ~s(<span class="verified no">○ unverified</span>)
      _ -> nil
    end
  end

  defp resource_row(fm) do
    case fm["resource"] do
      url when is_binary(url) and url != "" ->
        ~s(<a href="#{esc(url)}" rel="noopener noreferrer">#{esc(shorten_url(url))}</a>)

      _ ->
        nil
    end
  end

  defp text_row(v) when is_binary(v) and v != "", do: esc(v)
  defp text_row(_), do: nil

  defp id_row(id) when is_binary(id), do: ~s(<code>#{esc(id)}</code>)
  defp id_row(_), do: nil

  defp tags_row(page) do
    case List.wrap(page.fm["tags"]) do
      [] ->
        nil

      tags ->
        chips =
          Enum.map_join(tags, "", fn t ->
            t = to_string(t)
            ~s(<button type="button" class="tag" data-tag="#{esc(t)}">#{esc(t)}</button>)
          end)

        ~s(<div class="tags">#{chips}</div>)
    end
  end

  defp edges_row(ids, page, id_index) do
    case List.wrap(ids) do
      [] -> nil
      ids -> ~s(<ul class="edges">#{Enum.map_join(ids, "", &edge_item(&1, page, id_index))}</ul>)
    end
  end

  defp edge_item(id, page, id_index) do
    case Map.get(id_index, id) do
      nil -> ~s(<li><code>#{esc(id)}</code></li>)
      target -> ~s(<li><a href="#{href(page, target)}">#{esc(target.title)}</a></li>)
    end
  end

  defp cited_by_row(nil, _page, _backlinks), do: nil

  defp cited_by_row(id, page, backlinks) do
    case Map.get(backlinks, id, []) do
      [] ->
        nil

      citers ->
        items =
          citers
          |> Enum.sort_by(& &1.title)
          |> Enum.map_join("", fn c ->
            ~s(<li><a href="#{href(page, c)}">#{esc(c.title)}</a></li>)
          end)

        ~s(<ul class="edges">#{items}</ul>)
    end
  end

  defp shorten_url(url) do
    url
    |> String.replace(~r{^https?://}, "")
    |> String.replace(~r{^www\.}, "")
    |> then(fn s -> if String.length(s) > 48, do: String.slice(s, 0, 47) <> "…", else: s end)
  end

  # --- search index --------------------------------------------------------

  defp search_index(pages) do
    entries =
      pages
      |> Enum.reject(&(&1.kind in [:log]))
      |> Enum.map(fn p ->
        %{
          "t" => p.title,
          "u" => p.out,
          "y" => p.type || section_label(p),
          "d" => to_string(p.fm["description"] || ""),
          "g" => List.wrap(p.fm["tags"]) |> Enum.join(" "),
          "x" => plain_text(p.body)
        }
      end)

    json_array(entries)
  end

  defp section_label(%{kind: :root}), do: "home"
  defp section_label(%{kind: :index}), do: "index"
  defp section_label(_), do: "doc"

  # Rough markdown → plain text for search: drop code fences, comments, and
  # syntax noise, keep link labels, cap length.
  defp plain_text(body) do
    body
    |> String.replace(~r/```.*?```/s, " ")
    |> String.replace(~r/<!--.*?-->/s, " ")
    |> String.replace(~r/\[([^\]]*)\]\([^)]*\)/, "\\1")
    |> String.replace(~r/[#>*_`|-]/, " ")
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
    |> String.slice(0, 600)
  end

  # --- helpers -------------------------------------------------------------

  defp ctx(page), do: %{dir: page.dir, root_prefix: page.root_prefix}

  defp stringify(nil), do: nil
  defp stringify(v) when is_binary(v), do: v
  defp stringify(v), do: to_string(v)

  defp esc(text), do: Markdown.escape(to_string(text))

  # --- minimal JSON (no deps) ---------------------------------------------

  defp json_array(list) do
    "[" <> Enum.map_join(list, ",", &json_object/1) <> "]"
  end

  defp json_object(map) do
    "{" <>
      Enum.map_join(map, ",", fn {k, v} -> json_string(k) <> ":" <> json_string(v) end) <>
      "}"
  end

  defp json_string(s) do
    escaped =
      s
      |> to_string()
      |> String.replace("\\", "\\\\")
      |> String.replace("\"", "\\\"")
      |> String.replace("\n", "\\n")
      |> String.replace("\r", "")
      |> String.replace("\t", " ")

    "\"" <> escaped <> "\""
  end

  # --- assets --------------------------------------------------------------

  defp css, do: ElixirMind.Site.Assets.css()
  defp app_js, do: ElixirMind.Site.Assets.js()
end
