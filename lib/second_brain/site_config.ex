defmodule SecondBrain.SiteConfig do
  @moduledoc """
  Deploy-time configuration for the published site: the canonical **base URL** the
  bundle is served from, and the bundle-path → live-URL mapping derived from it.

  This is the single source of truth for *where the bundle is published*. The base
  URL is read from application config (`config/config.exs`), falling back to the
  GitHub Pages default so the tooling still runs in a bare checkout:

      config :second_brain, site_base_url: "https://ob6to8.github.io/second-brain/"

  Consumers:

    * `SecondBrain.Contract` expands the `{{site_base_url}}` token in policy bodies
      when compiling `CLAUDE.md`, so the contract states one config-driven URL.
    * `SecondBrain.Site` expands the same token when rendering pages, and reuses
      `excluded_dirs/0` so "not rendered → no live URL" stays consistent.
    * `mix brain.url` prints `live_url/1` for a bundle path.

  Change the deploy location (e.g. a custom domain) in one place — the config — then
  re-run `mix brain.contract` and `mix brain.site`.
  """

  @default_base_url "https://ob6to8.github.io/second-brain/"

  # Top-level directories the static site does not render (see SecondBrain.Site).
  # A resource under one of these has no page, hence no live URL.
  @excluded_dirs ~w(.git .github .githooks _build deps tmp deprecated .claude lib test)

  @doc """
  The canonical base URL the site is published under, normalized to a single
  trailing slash. Reads `:second_brain, :site_base_url`, defaulting to the
  GitHub Pages URL.
  """
  @spec base_url() :: String.t()
  def base_url do
    :second_brain
    |> Application.get_env(:site_base_url, @default_base_url)
    |> to_string()
    |> ensure_trailing_slash()
  end

  @doc "Top-level directories the site excludes (no page, no live URL)."
  @spec excluded_dirs() :: [String.t()]
  def excluded_dirs, do: @excluded_dirs

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
