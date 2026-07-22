defmodule ElixirMind.SiteConfigTest do
  use ExUnit.Case, async: true

  alias ElixirMind.SiteConfig

  describe "base_url/0" do
    test "reads config and normalizes to a single trailing slash" do
      assert String.ends_with?(SiteConfig.base_url(), "/")
      refute String.ends_with?(SiteConfig.base_url(), "//")
      assert SiteConfig.base_url() == "https://ob6to8.github.io/elixir-mind/"
    end
  end

  describe "live_url/1" do
    test "maps a bundle-absolute path, swapping .md for .html" do
      assert {:ok, url} =
               SiteConfig.live_url("/knowledge/knowledge-management/open-knowledge-format.md")

      assert url ==
               "https://ob6to8.github.io/elixir-mind/knowledge/knowledge-management/open-knowledge-format.html"
    end

    test "accepts a plain (non-leading-slash) path and governance docs" do
      assert {:ok,
              "https://ob6to8.github.io/elixir-mind/meta/policy/response-resource-links.html"} =
               SiteConfig.live_url("meta/policy/response-resource-links.md")
    end

    test "maps a directory index.md" do
      assert {:ok, "https://ob6to8.github.io/elixir-mind/knowledge/index.html"} =
               SiteConfig.live_url("/knowledge/index.md")
    end

    test "excluded directories have no live URL" do
      assert {:error, :not_rendered} = SiteConfig.live_url("deprecated/plans/004-cli-mcp-spec.md")
      assert {:error, :not_rendered} = SiteConfig.live_url("/lib/elixir_mind/site.ex")
      assert {:error, :not_rendered} = SiteConfig.live_url(".claude/skills/intake/SKILL.md")
    end

    test "blank path is rejected" do
      assert {:error, :empty} = SiteConfig.live_url("")
      assert {:error, :empty} = SiteConfig.live_url("/")
    end
  end

  describe "blob_url/2" do
    test "maps a path to its GitHub blob view at a ref, keeping the .md extension" do
      assert {:ok, url} =
               SiteConfig.blob_url(
                 "meta/doctrine/fit-each-layer-to-its-purpose.md",
                 "some-branch"
               )

      assert url ==
               "https://github.com/ob6to8/elixir-mind/blob/some-branch/meta/doctrine/fit-each-layer-to-its-purpose.md"
    end

    test "accepts a bundle-absolute path and works for non-rendered directories" do
      assert {:ok,
              "https://github.com/ob6to8/elixir-mind/blob/main/.claude/skills/intake/SKILL.md"} =
               SiteConfig.blob_url("/.claude/skills/intake/SKILL.md", "main")
    end

    test "blank path is rejected" do
      assert {:error, :empty} = SiteConfig.blob_url("", "main")
    end
  end

  describe "expand_tokens/1" do
    test "replaces the site_base_url token with the configured base URL" do
      assert SiteConfig.expand_tokens("see {{site_base_url}}P.html") ==
               "see https://ob6to8.github.io/elixir-mind/P.html"
    end

    test "leaves bodies without the token untouched" do
      assert SiteConfig.expand_tokens("no tokens here") == "no tokens here"
    end
  end
end
