defmodule Mix.Tasks.Brain.Url do
  @shortdoc "Print the deployed live-site URL for a bundle path"

  @moduledoc """
  Map a bundle path to its page on the deployed Pages site.

      mix brain.url knowledge/knowledge-management/open-knowledge-format.md
      mix brain.url /meta/policy/response-resource-links.md

  The mechanical form of the response-resource-links policy: use it to cite a brain
  resource by its live URL instead of hand-constructing one. The base URL comes from
  config (`SecondBrain.SiteConfig.base_url/0`). Paths under non-rendered directories
  (`deprecated/`, `.claude/`, `lib/`, `test/`, …) have no page and print a notice —
  cite those by repo path.
  """

  use Mix.Task

  @impl Mix.Task
  def run([path | _]) when is_binary(path) do
    case SecondBrain.SiteConfig.live_url(path) do
      {:ok, url} ->
        Mix.shell().info(url)

      {:error, :not_rendered} ->
        Mix.shell().error(
          "#{path}: not rendered to the site (excluded directory) — cite by repo path."
        )

      {:error, :empty} ->
        usage()
    end
  end

  def run(_), do: usage()

  defp usage do
    Mix.shell().error("usage: mix brain.url <bundle-path>")
    exit({:shutdown, 1})
  end
end
