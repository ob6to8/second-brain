defmodule Mix.Tasks.Brain.Glossary do
  @shortdoc "Verify the glossary's single-overview convention (lede, index gloss, body dedup)"

  @moduledoc """
  Verify the glossary layer (see `SecondBrain.Glossary` and the
  [glossary plan](/meta/plans/glossary-single-overview-and-dedup-check.md)):
  every term file carries a `description` (the one canonical overview, rendered
  as the entry lede), the index `## Terms` section matches its re-derivation
  from those descriptions verbatim, and no body sentence near-restates its
  entry's description — bodies are expansion-only.

      mix brain.glossary                # verify; exits non-zero on any failure
      mix brain.glossary --materialize  # regenerate the index `## Terms`
                                        # section from the term files, then verify

  Warnings never fail the task; only `:fail` results do.
  """

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {opts, _rest, _invalid} = OptionParser.parse(args, strict: [materialize: :boolean])

    if opts[:materialize] do
      case SecondBrain.Glossary.materialize() do
        :unchanged ->
          Mix.shell().info("Glossary: index `## Terms` section already current.")

        {:written, path} ->
          Mix.shell().info("Glossary: materialized `## Terms` section in #{path}.")
      end
    end

    results = SecondBrain.Glossary.run_checks()
    Enum.each(results, &report/1)

    if Enum.any?(results, fn {_, status, _} -> status == :fail end) do
      Mix.shell().error("\nGlossary verification FAILED.")
      exit({:shutdown, 1})
    else
      warns = Enum.count(results, fn {_, status, _} -> status == :warn end)

      suffix =
        if warns == 0, do: "", else: " (#{warns} warning(s) above — editorial, never failing)"

      Mix.shell().info(
        "\nGlossary verify: descriptions, index sync, and body dedup all check out." <> suffix
      )
    end
  end

  defp report({name, status, detail}) do
    marker =
      case status do
        :ok -> "ok  "
        :warn -> "warn"
        :fail -> "FAIL"
      end

    line = "  [#{marker}] #{name}: #{detail}"

    case status do
      :fail -> Mix.shell().error(line)
      _ -> Mix.shell().info(line)
    end
  end
end
