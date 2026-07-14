defmodule ElixirMind.IntakeScenarioTest do
  # Scenario test for the /intake flow's deterministic spine (see
  # meta/flows/intake.md and meta/plans/flows-genre-and-scenario-testing.md).
  #
  # /intake's judgment steps (gather, segment, dedup, distill, choose directory)
  # have no mechanical oracle; its spine is the identity handoff after a concept is
  # written: `mix brain.id` mints an id, `mix brain.registry` compiles the id→path
  # view, `mix brain.verify` validates conformance, edges, and grounding. Id
  # minting itself is random (not pinned); this scenario pins the rest — the
  # registry render is byte-checked (a targeted assertion) and the verifier's
  # green + red judgments are asserted structurally, matching the repo's pattern.
  use ExUnit.Case, async: true

  alias ElixirMind.{Registry, Verifier}

  @moduletag :tmp_dir

  # A representative intake output: a primary `source` capture, and a `claim`
  # distilled from it, grounded against that source via `verified_by`. Ids stand
  # in for what `mix brain.id` would mint (the mint is random, so it isn't pinned).
  @source_row "| `sb:bbb222` | [sources/paper](/sources/paper.md) | source |  |"
  @claim_row "| `sb:aaa111` | [SWE/topic/insight](/SWE/topic/insight.md) | claim | true |"

  setup %{tmp_dir: root} do
    File.mkdir_p!(Path.join(root, "meta"))
    File.mkdir_p!(Path.join(root, "sources"))
    File.mkdir_p!(Path.join(root, "SWE/topic"))

    write(root, "sources/paper.md", """
    ---
    id: sb:bbb222
    type: source
    title: A primary source
    resource: https://example.com/paper
    provenance: "Extracted from https://example.com/paper"
    attribution:
      when: 2026-07-13T10:00:00Z
      channel: intake
      agent: "operator via /intake"
      why: "operator pasted the paper"
    ---

    > A verbatim supporting passage.
    """)

    write(root, "SWE/topic/insight.md", """
    ---
    id: sb:aaa111
    type: claim
    title: A grounded insight
    description: One sentence.
    verified: true
    verified_by: [sb:bbb222]
    attribution:
      when: 2026-07-13T10:00:00Z
      channel: intake
      agent: "operator via /intake"
      why: "operator pasted the paper"
    ---

    A distilled statement, grounded by [the source](/sources/paper.md).
    """)

    %{root: root}
  end

  test "an intook, grounded concept compiles into the registry and verifies clean", %{root: root} do
    # `mix brain.registry` analog: materialize the id→path view, then it round-trips.
    Registry.write(root)
    assert Registry.check(root) == :ok

    # Targeted oracle: the render is byte-exact for both rows — id, path, type, and
    # the `verified` column (true for the grounded claim, empty for the capture).
    rendered = Registry.render(root)
    assert rendered =~ @claim_row
    assert rendered =~ @source_row

    # Structured oracle: conformance, id format, edge resolution, and grounding.
    assert Verifier.run(root) == :ok
  end

  test "before an id is minted, the verifier flags the concept (the mint handoff)", %{root: root} do
    write(root, "SWE/topic/no-id.md", """
    ---
    type: note
    title: Freshly distilled, not yet minted
    ---

    Body.
    """)

    assert {:error, errors} = Verifier.run(root)
    assert Enum.any?(errors, &(&1 =~ "SWE/topic/no-id.md" and &1 =~ "missing stable"))
  end

  test "a capture marked verified is rejected (captures are not verifiable)", %{root: root} do
    # A common intake mistake: a `reference` that stores a link cannot be verified.
    write(root, "SWE/topic/bad-capture.md", """
    ---
    id: sb:ccc333
    type: reference
    title: A capture wrongly marked verified
    resource: https://example.com/article
    verified: true
    ---

    Summary.
    """)

    assert {:error, errors} = Verifier.run(root)
    assert Enum.any?(errors, &(&1 =~ "bad-capture.md" and &1 =~ "stores a link"))
  end

  defp write(root, rel, body), do: File.write!(Path.join(root, rel), body)
end
