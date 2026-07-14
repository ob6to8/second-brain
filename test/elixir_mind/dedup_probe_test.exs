defmodule ElixirMind.DedupProbeTest do
  use ExUnit.Case, async: true

  alias ElixirMind.DedupProbe
  alias ElixirMind.DedupProbe.Row

  @moduletag :tmp_dir

  # A concept lives in a non-excluded top dir so Registry.concept_paths finds it.
  defp write_concept(dir, slug, id, title, body) do
    path = Path.join([dir, "kb", "#{slug}.md"])
    File.mkdir_p!(Path.dirname(path))

    File.write!(
      path,
      "---\nid: #{id}\ntype: reference\ntitle: \"#{title}\"\n---\n#{body}\n"
    )
  end

  defp write_gold(dir, rows, baseline) do
    path = Path.join([dir, "meta", "evals", "dedup-probe.md"])
    File.mkdir_p!(Path.dirname(path))

    gold_table =
      [
        "| query | acceptable ids | band | variants | note |",
        "|-------|----------------|------|----------|------|"
        | Enum.map(rows, fn {q, ids, band, variants, note} ->
            "| #{q} | #{ids} | #{band} | #{variants} | #{note} |"
          end)
      ]
      |> Enum.join("\n")

    baseline_table =
      [
        "| mode | hits | targets |",
        "|------|------|---------|"
        | Enum.map(baseline, fn {mode, h, t} -> "| #{mode} | #{h} | #{t} |" end)
      ]
      |> Enum.join("\n")

    body = """
    # Gold

    Intro prose.

    ## Gold set

    #{gold_table}

    ## Baseline

    #{baseline_table}
    """

    File.write!(path, "---\ntype: reference\ntitle: gold\n---\n#{body}")
  end

  # A fixture corpus + gold set exercising every band and both modes.
  defp fixture(dir) do
    write_concept(
      dir,
      "alpha",
      "sb:aaaaaa",
      "Alpha",
      "Alpha discusses context poisoning at length."
    )

    write_concept(dir, "beta", "sb:bbbbbb", "Beta", "Beta covers a reranking step over results.")

    write_gold(
      dir,
      [
        {"context poisoning", "sb:aaaaaa", "target", "—", "control hit"},
        {"context pollution", "sb:aaaaaa", "target", "context poisoning",
         "miss plain, recovered expanded"},
        {"totally absent phrase", "sb:bbbbbb", "target", "reranking",
         "miss plain, recovered expanded"},
        {"reranking", "sb:aaaaaa sb:bbbbbb", "negative", "—", "non-dup pair"},
        {"future term", "sb:bbbbbb", "quarantine", "—", "undefined until supersession"}
      ],
      [{"plain", 1, 3}, {"expanded", 3, 3}]
    )
  end

  test "parses rows: bands, id sets, and variants", %{tmp_dir: dir} do
    fixture(dir)

    rows = DedupProbe.parse_gold!(dir)
    assert length(rows) == 5

    assert Enum.map(rows, & &1.band) == ~w(target target target negative quarantine)

    pollution = Enum.find(rows, &(&1.query == "context pollution"))
    assert %Row{acceptable_ids: ["sb:aaaaaa"], variants: ["context poisoning"]} = pollution

    negative = Enum.find(rows, &(&1.band == "negative"))
    assert negative.acceptable_ids == ["sb:aaaaaa", "sb:bbbbbb"]
    assert negative.variants == []
  end

  test "plain mode: hit iff the query itself surfaces an acceptable id", %{tmp_dir: dir} do
    fixture(dir)

    %{results: results, aggregate: agg} = DedupProbe.run(dir)

    assert agg == %{hits: 1, targets: 3}

    by_query = Map.new(results, &{&1.query, &1})
    assert by_query["context poisoning"].hit
    refute by_query["context pollution"].hit
    refute by_query["totally absent phrase"].hit
    # the primary-query match-set size is reported even on a miss
    assert by_query["context poisoning"].match_set_size == 1
  end

  test "expanded mode: a recorded variant recovers a plain miss", %{tmp_dir: dir} do
    fixture(dir)

    %{results: results, aggregate: agg} = DedupProbe.run(dir, expanded: true)

    assert agg == %{hits: 3, targets: 3}

    by_query = Map.new(results, &{&1.query, &1})
    assert by_query["context pollution"].hit
    assert by_query["context pollution"].via == "context poisoning"
    assert by_query["totally absent phrase"].via == "reranking"
    # a plain hit records no `via` (the bare query matched)
    assert by_query["context poisoning"].via == nil
  end

  test "band handling: negatives and quarantine are parsed but never scored", %{tmp_dir: dir} do
    fixture(dir)

    %{results: results, aggregate: agg} = DedupProbe.run(dir)

    # aggregate counts target rows only, though 5 rows were parsed
    assert length(results) == 5
    assert agg.targets == 3

    bands = results |> Enum.map(& &1.band) |> Enum.frequencies()
    assert bands == %{"target" => 3, "negative" => 1, "quarantine" => 1}

    report = DedupProbe.report(dir)
    assert report =~ "## Negatives (1) — reported, not scored"
    assert report =~ "## Quarantine (1) — reported, not scored"
    # the quarantine row's query never appears in the scored Targets table
    [targets_section, _] = String.split(report, "## Negatives")
    refute targets_section =~ "future term"
  end

  test "baseline delta renders against the committed figures", %{tmp_dir: dir} do
    fixture(dir)

    # matches the committed plain baseline of 1/3
    assert DedupProbe.report(dir) =~ "Recall (plain): 1/3 = 33%** — no change vs baseline"

    # now record a lower baseline and confirm the delta reflects improvement
    write_gold(
      dir,
      [
        {"context poisoning", "sb:aaaaaa", "target", "—", "control hit"},
        {"context pollution", "sb:aaaaaa", "target", "context poisoning", "recovered expanded"},
        {"totally absent phrase", "sb:bbbbbb", "target", "reranking", "recovered expanded"},
        {"reranking", "sb:aaaaaa sb:bbbbbb", "negative", "—", "non-dup pair"},
        {"future term", "sb:bbbbbb", "quarantine", "—", "undefined"}
      ],
      [{"plain", 0, 3}, {"expanded", 3, 3}]
    )

    assert DedupProbe.report(dir) =~ "+1 vs baseline"
  end

  test "missing gold doc raises", %{tmp_dir: dir} do
    File.mkdir_p!(Path.join(dir, "meta"))
    assert_raise ArgumentError, ~r/gold doc not found/, fn -> DedupProbe.parse_gold!(dir) end
  end

  test "update_baseline regenerates the table and preserves surrounding prose", %{tmp_dir: dir} do
    fixture(dir)

    # start from deliberately-wrong committed figures
    write_gold(
      dir,
      [
        {"context poisoning", "sb:aaaaaa", "target", "—", "control hit"},
        {"context pollution", "sb:aaaaaa", "target", "context poisoning", "recovered expanded"},
        {"totally absent phrase", "sb:bbbbbb", "target", "reranking", "recovered expanded"},
        {"reranking", "sb:aaaaaa sb:bbbbbb", "negative", "—", "non-dup pair"},
        {"future term", "sb:bbbbbb", "quarantine", "—", "undefined"}
      ],
      [{"plain", 9, 9}, {"expanded", 9, 9}]
    )

    # add a trailing prose paragraph after the baseline table to prove it survives
    path = Path.join([dir, "meta", "evals", "dedup-probe.md"])
    File.write!(path, File.read!(path) <> "\nTrailing prose after the table.\n")

    DedupProbe.update_baseline(dir)

    # table now reflects the live fixture measurement (plain 1/3, expanded 3/3)
    assert DedupProbe.parse_baseline(dir) == %{"plain" => {1, 3}, "expanded" => {3, 3}}

    body = File.read!(path)
    assert body =~ "Trailing prose after the table."
    # idempotent: a second run leaves exactly one pair of data rows
    DedupProbe.update_baseline(dir)
    assert body == File.read!(path)
  end
end
