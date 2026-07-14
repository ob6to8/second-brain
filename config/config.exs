import Config

# Where the knowledge bundle is published. `ElixirMind.SiteConfig.base_url/0`
# reads this; the contract compiler and the static-site generator both derive
# their live URLs from it, so a deploy move (e.g. a custom domain) is a one-line
# change here followed by `mix brain.contract` + `mix brain.site`.
config :elixir_mind,
  site_base_url: "https://ob6to8.github.io/second-brain/",
  # Where the repository itself lives (PR links in generated views, e.g.
  # `mix brain.dev_history`). `ElixirMind.SiteConfig.repo_url/0` reads this.
  repo_url: "https://github.com/ob6to8/second-brain"
