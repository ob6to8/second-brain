defmodule Mix.Tasks.Brain.Attribution do
  @shortdoc "Query the attribution layer; --backfill reconstructs missing events from git"

  @moduledoc """
  The attribution layer's command surface (see `ElixirMind.Attribution` and
  `meta/policy/resource-attribution.md`).

      mix brain.attribution [--channel CHANNEL] [--since YYYY-MM-DD]

  List attributed docs, newest first: ingestion instant, channel, id/path,
  and the recorded why. The operator's post-auto-intake editorial pass is
  `mix brain.attribution --channel auto-intake --since <last-review-date>`.

      mix brain.attribution --backfill

  One-shot reconstruction of `attribution` for docs that predate the policy
  (see `ElixirMind.Attribution.Backfill` for the derivation rules). Files
  already carrying the field are skipped; review the diff before committing.
  """

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {opts, rest, invalid} =
      OptionParser.parse(args, strict: [backfill: :boolean, channel: :string, since: :string])

    cond do
      invalid != [] or rest != [] ->
        Mix.shell().error(
          "usage: mix brain.attribution [--channel CHANNEL] [--since YYYY-MM-DD] | --backfill"
        )

        exit({:shutdown, 1})

      opts[:backfill] ->
        {written, skipped} = ElixirMind.Attribution.Backfill.run()

        Mix.shell().info(
          "Backfilled attribution into #{length(written)} doc(s); " <>
            "#{length(skipped)} already carried it and were left untouched."
        )

      true ->
        list(opts)
    end
  end

  defp list(opts) do
    rows = ElixirMind.Attribution.list(File.cwd!(), opts)

    Enum.each(rows, fn row ->
      date = String.slice(row.when, 0, 10)
      ref = if row.id, do: "#{row.id} #{row.path}", else: row.path
      why = if row.why, do: " — #{row.why}", else: ""

      Mix.shell().info("#{date}  #{String.pad_trailing(row.channel || "?", 14)} #{ref}#{why}")
    end)

    Mix.shell().info("\n#{length(rows)} attributed doc(s) matched.")
  end
end
