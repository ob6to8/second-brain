defmodule ElixirMind.Contract do
  @moduledoc """
  Compiles `CLAUDE.md` — the operating contract every agent reads — from its source
  documents:

    * `meta/preamble.md`  — the fixed framing/intro (plain markdown, no frontmatter)
    * `meta/policy/*.md`  — the rules, as `type: policy` OKF docs (see `ElixirMind.Policy`)

  Each policy is grouped under its declared `section` and rendered in `order`, with a
  visible trace link back to its source document. `CLAUDE.md` is therefore a generated
  artifact: never hand-edited, always reproducible via `mix brain.contract`.
  """

  alias ElixirMind.Policy

  @output "CLAUDE.md"
  @preamble "meta/preamble.md"

  # Ordered contract sections. `{key, heading}` — the number is the 1-based position.
  # A policy's `section` frontmatter must match one of these keys.
  @sections [
    {"composition", "What the brain is made of"},
    {"directory-structure", "Directory structure — unix-like, domain-agnostic, evolving"},
    {"filing", "Filing conventions"},
    {"type-vocabulary", "Controlled `type` vocabulary"},
    {"verification", "Identity & verification"},
    {"conformance", "Conformance (keep the bundle valid)"},
    {"skills", "Skills"},
    {"session-workflow", "Session capture, routing & route tags"},
    {"git-workflow", "Git workflow"},
    {"tooling-standards", "Elixir tooling — coding standards"}
  ]

  @banner """
  <!--
    GENERATED FILE — do not edit by hand.
    Source of truth: meta/preamble.md + meta/policy/*.md
    Regenerate:      mix brain.contract
    Verify (CI):     mix brain.contract --check
  -->
  """

  @doc "Path of the generated contract, relative to repo root."
  def output_path, do: @output

  @doc "Render the full `CLAUDE.md` contents as a string."
  @spec render(String.t()) :: String.t()
  def render(root \\ File.cwd!()) do
    policies = Policy.load_all(root)
    validate_sections!(policies)

    grouped = Enum.group_by(policies, & &1.section)

    preamble =
      root
      |> Path.join(@preamble)
      |> File.read!()
      |> preamble_body()
      |> ElixirMind.SiteConfig.expand_tokens()
      |> String.trim()

    body =
      @sections
      |> Enum.with_index(1)
      |> Enum.map(fn {{key, heading}, number} ->
        render_section(number, heading, Map.get(grouped, key, []))
      end)
      |> Enum.join("\n\n---\n\n")

    IO.iodata_to_binary([
      String.trim(@banner),
      "\n\n",
      preamble,
      "\n\n---\n\n",
      body,
      "\n"
    ])
  end

  @doc "Render and write `CLAUDE.md`. Returns the output path."
  @spec write(String.t()) :: String.t()
  def write(root \\ File.cwd!()) do
    path = Path.join(root, @output)
    File.write!(path, render(root))
    path
  end

  @doc """
  Check whether the on-disk `CLAUDE.md` matches a fresh render.
  Returns `:ok` or `{:stale, diff_summary}`.
  """
  @spec check(String.t()) :: :ok | {:stale, String.t()}
  def check(root \\ File.cwd!()) do
    path = Path.join(root, @output)
    expected = render(root)
    actual = if File.exists?(path), do: File.read!(path), else: ""

    if expected == actual, do: :ok, else: {:stale, first_diff(expected, actual)}
  end

  # The preamble may carry OKF frontmatter (to stay bundle-conformant) or be plain
  # markdown; either way we render only its body.
  defp preamble_body(content) do
    case ElixirMind.Frontmatter.parse(content) do
      {:ok, %{body: body}} -> body
      {:error, _} -> content
    end
  end

  # --- rendering -----------------------------------------------------------

  defp render_section(number, heading, policies) do
    rendered =
      policies
      |> Enum.map(&render_policy/1)
      |> Enum.join("\n\n")

    "## #{number}. #{heading}\n\n#{rendered}"
  end

  defp render_policy(%Policy{} = p) do
    body = ElixirMind.SiteConfig.expand_tokens(p.body)
    "#{body}\n\n_Source: [`meta/policy/#{p.id}.md`](/meta/policy/#{p.id}.md)_"
  end

  # --- validation ----------------------------------------------------------

  defp validate_sections!(policies) do
    known = MapSet.new(@sections, fn {key, _} -> key end)

    for %Policy{section: section, path: path} <- policies, not MapSet.member?(known, section) do
      raise ArgumentError,
            "#{path}: unknown contract section #{inspect(section)}. " <>
              "Known sections: #{known |> MapSet.to_list() |> Enum.sort() |> Enum.join(", ")}"
    end

    :ok
  end

  defp first_diff(expected, actual) do
    exp = String.split(expected, "\n")
    act = String.split(actual, "\n")

    Enum.zip(exp, act)
    |> Enum.with_index(1)
    |> Enum.find(fn {{e, a}, _} -> e != a end)
    |> case do
      nil ->
        "length differs (expected #{length(exp)} lines, on disk #{length(act)})"

      {{e, a}, line} ->
        "first diff at line #{line}:\n  expected: #{inspect(e)}\n  on disk:  #{inspect(a)}"
    end
  end
end
