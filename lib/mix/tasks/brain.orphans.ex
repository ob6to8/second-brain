defmodule Mix.Tasks.Brain.Orphans do
  @shortdoc "List docs with no inbound internal link (filed but never referenced)"

  @moduledoc """
  Report docs that nothing else links to — filed but never cross-referenced.

      mix brain.orphans                 # knowledge + governance docs, index listings ignored
      mix brain.orphans --include-index # also count links inside index.md listings
      mix brain.orphans --all           # include meta/threads/ and inbox/ (anchored by design)

  By default `index.md` listings don't count as inbound links (every filed doc is
  listed in one, which would hide every real orphan), and the anchored-by-design
  namespaces `meta/threads/` and `inbox/` are excluded from candidates. See
  `ElixirMind.Orphans` for the scoping rules. Read-only.
  """

  use Mix.Task

  alias ElixirMind.Orphans

  @impl Mix.Task
  def run(argv) do
    {opts, _, _} =
      OptionParser.parse(argv, strict: [include_index: :boolean, all: :boolean])

    case Orphans.find(File.cwd!(), opts) do
      [] ->
        Mix.shell().info("No orphans — every candidate doc has an inbound link.")

      orphans ->
        Mix.shell().info("#{length(orphans)} orphan doc(s) with no inbound link:\n")
        Enum.each(orphans, &Mix.shell().info("  #{&1}"))
    end
  end
end
