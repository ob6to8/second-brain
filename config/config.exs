import Config

# Where the knowledge bundle is published. `SecondBrain.SiteConfig.base_url/0`
# reads this; the contract compiler and the static-site generator both derive
# their live URLs from it, so a deploy move (e.g. a custom domain) is a one-line
# change here followed by `mix brain.contract` + `mix brain.site`.
config :second_brain,
  site_base_url: "https://ob6to8.github.io/second-brain/"
