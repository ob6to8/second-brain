defmodule Mix.Tasks.Brain.Site do
  @shortdoc "Generate the static GitHub Pages site from the knowledge bundle"

  @moduledoc """
  Render the OKF bundle into a self-contained, navigable static site.

      mix brain.site              # build into _site/
      mix brain.site --out DIR    # build into a custom output directory

  The output is dependency-free HTML/CSS/JS: a sidebar mirroring the directory
  taxonomy, per-concept metadata panels (type, tags, verification, evidence edges),
  and a client-side search index. All links are relative, so the site works at a
  domain root or under a project subpath (e.g. `/elixir-mind/`). Deployed to
  GitHub Pages by `.github/workflows/pages.yml`.
  """

  use Mix.Task

  alias ElixirMind.Site

  @impl Mix.Task
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, strict: [out: :string])
    out = opts[:out] || Site.default_out()

    count = Site.build(File.cwd!(), out)
    Mix.shell().info("Built #{count} pages into #{out}/")
  end
end
