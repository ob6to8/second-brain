defmodule ElixirMind.SiteConfig do
  @moduledoc """
  Deploy-time configuration for the published site: the canonical **base URL** the
  bundle is served from, and the bundle-path → live-URL mapping derived from it.

  This is the single source of truth for *where the bundle is published*. The base
  URL is read from application config (`config/config.exs`), falling back to the
  GitHub Pages default so the tooling still runs in a bare checkout:

      config :elixir_mind, site_base_url: "https://ob6to8.github.io/elixir-mind/"

  Consumers:

    * `ElixirMind.Contract` expands the `{{site_base_url}}` token in policy bodies
      when compiling `CLAUDE.md`, so the contract states one config-driven URL.
    * `ElixirMind.Site` expands the same token when rendering pages, and reuses
      `excluded_dirs/0` so "not rendered → no live URL" stays consistent.
    * `mix brain.url` prints `live_url/1` for a bundle path.

  Change the deploy location (e.g. a custom domain) in one place — the config — then
  re-run `mix brain.contract` and `mix brain.site`.
  """

  @default_base_url "https://ob6to8.github.io/elixir-mind/"

  # Top-level directories the static site does not render (see ElixirMind.Site).
  # A resource under one of these has no page, hence no live URL.
  @excluded_dirs ~w(.git .github .githooks _build deps tmp deprecated .claude lib test)

  @doc """
  The canonical base URL the site is published under, normalized to a single
  trailing slash. Reads `:elixir_mind, :site_base_url`, defaulting to the
  GitHub Pages URL.
  """
  @spec base_url() :: String.t()
  def base_url do
    :elixir_mind
    |> Application.get_env(:site_base_url, @default_base_url)
    |> to_string()
    |> ensure_trailing_slash()
  end

  @doc "Top-level directories the site excludes (no page, no live URL)."
  @spec excluded_dirs() :: [String.t()]
  def excluded_dirs, do: @excluded_dirs

  @doc """
  The repository's home on GitHub (no trailing slash), for PR/commit links in
  generated views. Reads `:elixir_mind, :repo_url`; `nil` when unconfigured
  (consumers then render plain `PR #N` text instead of links).
  """
  @spec repo_url() :: String.t() | nil
  def repo_url do
    case Application.get_env(:elixir_mind, :repo_url) do
      nil -> nil
      url -> url |> to_string() |> String.trim_trailing("/")
    end
  end

  @doc """
  Map a bundle path to its page on the deployed site.

  Accepts a bundle-absolute (`/knowledge/x.md`) or plain (`meta/policy/y.md`) path;
  swaps the `.md` extension for `.html` and prepends `base_url/0`. Returns
  `{:error, :not_rendered}` for paths under an excluded directory (cite those by
  repo path instead), or `{:error, :empty}` for a blank path.
  """
  @spec live_url(String.t()) :: {:ok, String.t()} | {:error, :not_rendered | :empty}
  def live_url(bundle_path) do
    rel = bundle_path |> to_string() |> String.trim_leading("/")

    cond do
      rel == "" -> {:error, :empty}
      excluded?(rel) -> {:error, :not_rendered}
      true -> {:ok, base_url() <> String.replace_suffix(rel, ".md", ".html")}
    end
  end

  @doc """
  Map a bundle path to its file view on GitHub at a given ref (branch, tag, or
  SHA): `repo_url/0` + `/blob/<ref>/<path>`.

  Unlike `live_url/1` this keeps the `.md` extension (GitHub renders the markdown
  itself) and works for **any** in-repo path, including directories the site does
  not render. It is the citation form for a document that is **not yet live on the
  deployed site** — new or modified on an unmerged branch — because Pages deploys
  only from the default branch, so the Pages URL would 404 (new) or show stale
  content (modified) until the branch merges. Returns `{:error, :no_repo}` when
  `repo_url/0` is unconfigured, `{:error, :empty}` for a blank path.
  """
  @spec blob_url(String.t(), String.t()) :: {:ok, String.t()} | {:error, :no_repo | :empty}
  def blob_url(bundle_path, ref) when is_binary(ref) do
    rel = bundle_path |> to_string() |> String.trim_leading("/")

    cond do
      rel == "" -> {:error, :empty}
      repo_url() == nil -> {:error, :no_repo}
      true -> {:ok, repo_url() <> "/blob/" <> ref <> "/" <> rel}
    end
  end

  @doc """
  Expand deploy tokens in a markdown body. Currently `{{site_base_url}}` →
  `base_url/0`. Applied by both the contract compiler and the site renderer so the
  one config value reaches every rendered surface.
  """
  @spec expand_tokens(String.t()) :: String.t()
  def expand_tokens(body) when is_binary(body) do
    String.replace(body, "{{site_base_url}}", base_url())
  end

  defp excluded?(rel) do
    [top | _] = Path.split(rel)
    top in @excluded_dirs
  end

  defp ensure_trailing_slash(url) do
    if String.ends_with?(url, "/"), do: url, else: url <> "/"
  end
end
