defmodule ElixirMind.ContractScenarioTest do
  # Scenario test for the /render-contract flow's deterministic spine (see
  # meta/flows/render-contract.md and meta/plans/flows-genre-and-scenario-testing.md).
  #
  # Unlike /intake or /capture, this flow is nearly all spine — the editorial half
  # is only the rule's prose and its section/order placement. The scenario drives a
  # canonical run: policy sources compile into the artifact and the check
  # round-trips; a source edit without a recompile is caught as stale (the
  # forgotten-recompile handoff); a hand edit to the artifact is caught (the
  # never-hand-edit invariant); a policy naming an unregistered section fails the
  # compile (sections are code); and a superseded policy drops out on the next
  # compile while staying filed. ElixirMind.ContractTest unit-tests the compiler;
  # this scenario pins the flow's handoffs.
  use ExUnit.Case, async: true

  alias ElixirMind.Contract

  @moduletag :tmp_dir

  setup %{tmp_dir: root} do
    File.mkdir_p!(Path.join(root, "meta/policy"))
    File.write!(Path.join(root, "meta/preamble.md"), "# Operating Contract\n\nPreamble prose.")

    # A representative pair of rules in two sections — one of them in the section
    # rendered last, pinning the full @sections ordering.
    write_policy(root, "distill-dont-dump", "filing", 1, "Capture the knowledge, not the noise.")
    write_policy(root, "git-branch-deletion", "git-workflow", 1, "Delete merged head branches.")

    %{root: root}
  end

  test "a canonical run: compile, round-trip, catch source drift, recompile", %{root: root} do
    # `mix brain.contract` analog: materialize the artifact, then it round-trips.
    Contract.write(root)
    assert Contract.check(root) == :ok

    # Targeted oracle: banner, preamble, numbered section headings from @sections,
    # and the rendered rule with its trace link, byte-exact.
    rendered = File.read!(Path.join(root, Contract.output_path()))
    assert String.starts_with?(rendered, "<!--")
    assert rendered =~ "Preamble prose."
    assert rendered =~ "## 3. Filing conventions"
    assert rendered =~ "## 9. Git workflow"

    assert rendered =~
             "Delete merged head branches.\n\n" <>
               "_Source: [`meta/policy/git-branch-deletion.md`](/meta/policy/git-branch-deletion.md)_"

    # The forgotten-recompile handoff: editing a policy source strands the
    # on-disk artifact...
    write_policy(root, "git-branch-deletion", "git-workflow", 1, "Delete on sight.")
    assert {:stale, _summary} = Contract.check(root)

    # ...until the recompile restores the round-trip.
    Contract.write(root)
    assert Contract.check(root) == :ok
  end

  test "a hand edit to the artifact fails the drift gate", %{root: root} do
    Contract.write(root)
    path = Path.join(root, Contract.output_path())
    File.write!(path, String.replace(File.read!(path), "noise", "raw noise"))

    assert {:stale, _summary} = Contract.check(root)
  end

  test "a policy naming an unregistered section fails the compile (sections are code)", %{
    root: root
  } do
    write_policy(root, "stray-rule", "git-hygiene", 1, "A rule with no section to render into.")

    assert_raise ArgumentError, ~r/unknown contract section "git-hygiene"/, fn ->
      Contract.render(root)
    end
  end

  test "a superseded policy drops out on the next compile but stays filed", %{root: root} do
    Contract.write(root)
    assert File.read!(Path.join(root, Contract.output_path())) =~ "not the noise."

    write_policy(root, "distill-dont-dump", "filing", 1, "Capture the knowledge, not the noise.",
      status: "superseded"
    )

    assert {:stale, _summary} = Contract.check(root)

    Contract.write(root)
    refute File.read!(Path.join(root, Contract.output_path())) =~ "not the noise."
    assert File.exists?(Path.join(root, "meta/policy/distill-dont-dump.md"))
  end

  defp write_policy(root, id, section, order, body, opts \\ []) do
    status = Keyword.get(opts, :status, "active")

    File.write!(Path.join(root, "meta/policy/#{id}.md"), """
    ---
    type: policy
    title: #{id}
    section: #{section}
    order: #{order}
    status: #{status}
    ---
    #{body}
    """)
  end
end
