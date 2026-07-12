defmodule SecondBrain.GlossaryTest do
  use ExUnit.Case, async: true

  alias SecondBrain.Glossary

  @moduletag :tmp_dir

  # ---------------------------------------------------------------------
  # fixtures
  # ---------------------------------------------------------------------

  defp write_term(root, slug, fields, body) do
    dir = Path.join(root, "beliefs/glossary")
    File.mkdir_p!(dir)

    fm =
      fields
      |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
      |> Enum.join("\n")

    File.write!(Path.join(dir, "#{slug}.md"), "---\n#{fm}\n---\n\n#{body}")
  end

  defp write_index(root, terms_section) do
    dir = Path.join(root, "beliefs/glossary")
    File.mkdir_p!(dir)

    File.write!(Path.join(dir, "index.md"), """
    # Glossary

    Hand-written prose above the listing.

    #{terms_section}
    """)
  end

  defp check(results, name) do
    {^name, status, detail} = List.keyfind(results, name, 0)
    {status, detail}
  end

  defp seed_valid(root) do
    write_term(
      root,
      "actor-model",
      [type: "concept", title: "actor model", description: "Share-nothing concurrency."],
      """
      # actor model

      The BEAM is the canonical industrial implementation.

      *Seen in:* [a thread](/meta/threads/t.md)
      """
    )

    write_term(
      root,
      "backpressure",
      [
        type: "concept",
        title: "backpressure",
        description: "Downstream pushes back on producers."
      ],
      """
      # backpressure

      Bounded queues and pool limits are the usual mechanisms.
      """
    )

    write_index(root, """
    ## Terms

    - [actor model](/beliefs/glossary/actor-model.md) — Share-nothing concurrency.
    - [backpressure](/beliefs/glossary/backpressure.md) — Downstream pushes back on producers.
    """)
  end

  # ---------------------------------------------------------------------
  # descriptions + index sync
  # ---------------------------------------------------------------------

  describe "run_checks/1" do
    test "a conforming glossary passes every check", %{tmp_dir: root} do
      seed_valid(root)
      results = Glossary.run_checks(root)
      assert {:ok, _} = check(results, "descriptions")
      assert {:ok, _} = check(results, "index sync")
      assert {:ok, _} = check(results, "repetition")
    end

    test "a term without a description fails", %{tmp_dir: root} do
      seed_valid(root)
      write_term(root, "no-desc", [type: "concept", title: "no desc"], "# no desc\n")

      {status, detail} = Glossary.run_checks(root) |> check("descriptions")
      assert status == :fail
      assert detail =~ "no-desc.md"
    end

    test "an index gloss that paraphrases instead of quoting the description fails",
         %{tmp_dir: root} do
      seed_valid(root)

      write_index(root, """
      ## Terms

      - [actor model](/beliefs/glossary/actor-model.md) — concurrency without sharing
      - [backpressure](/beliefs/glossary/backpressure.md) — Downstream pushes back on producers.
      """)

      {status, detail} = Glossary.run_checks(root) |> check("index sync")
      assert status == :fail
      assert detail =~ "--materialize"
    end

    test "a missing or unordered term bullet fails index sync", %{tmp_dir: root} do
      seed_valid(root)

      write_index(root, """
      ## Terms

      - [backpressure](/beliefs/glossary/backpressure.md) — Downstream pushes back on producers.
      - [actor model](/beliefs/glossary/actor-model.md) — Share-nothing concurrency.
      """)

      assert {:fail, _} = Glossary.run_checks(root) |> check("index sync")
    end

    test "an index without a Terms section fails", %{tmp_dir: root} do
      seed_valid(root)
      File.write!(Path.join(root, "beliefs/glossary/index.md"), "# Glossary\n\nProse only.\n")

      {status, detail} = Glossary.run_checks(root) |> check("index sync")
      assert status == :fail
      assert detail =~ "## Terms"
    end
  end

  # ---------------------------------------------------------------------
  # repetition heuristic
  # ---------------------------------------------------------------------

  describe "repetition check" do
    # The red test: a body that stacks a second, lightly reworded definition
    # under the lede must be flagged (this is the failure mode the check exists
    # to catch — see the glossary plan).
    test "a body sentence restating the description fails", %{tmp_dir: root} do
      desc =
        "A concurrency model in which independent share-nothing processes own private " <>
          "state and interact only by asynchronous message passing, so contention becomes " <>
          "a message queue rather than a lock."

      write_term(
        root,
        "actor-model",
        [type: "concept", title: "actor model", description: desc],
        """
        # actor model

        A concurrency model in which independent processes share nothing: each owns its private state, and contention over a resource becomes a queue of asynchronous messages rather than a lock.

        *Seen in:* [a thread](/meta/threads/t.md)
        """
      )

      write_index(
        root,
        "## Terms\n\n- [actor model](/beliefs/glossary/actor-model.md) — #{desc}\n"
      )

      {status, detail} = Glossary.run_checks(root) |> check("repetition")
      assert status == :fail
      assert detail =~ "actor-model.md"
    end

    test "an expansion-only body passes", %{tmp_dir: root} do
      desc =
        "A concurrency model in which independent share-nothing processes own private " <>
          "state and interact only by asynchronous message passing."

      write_term(
        root,
        "actor-model",
        [type: "concept", title: "actor model", description: desc],
        """
        # actor model

        Ownership is the natural idiom for write governance: one broker process can own mutation of a namespace, and every other party submits requests to it. The BEAM is the canonical industrial implementation.

        *Seen in:* [a thread](/meta/threads/t.md)
        """
      )

      write_index(
        root,
        "## Terms\n\n- [actor model](/beliefs/glossary/actor-model.md) — #{desc}\n"
      )

      assert {:ok, _} = Glossary.run_checks(root) |> check("repetition")
    end

    test "citation lines and generated excerpt logs are exempt", %{tmp_dir: root} do
      desc = "The fraction of relevant items a search actually surfaces for a query."

      write_term(
        root,
        "recall",
        [type: "concept", title: "recall", description: desc],
        """
        # recall

        *Seen in:* [the fraction of relevant items a search actually surfaces for a query](/meta/threads/t.md)

        ## Thread excerpts — route-tagged log

        Generated — never hand-edit.

        The fraction of relevant items that a search actually surfaces for a query is what recall names, and this frozen excerpt may restate it verbatim without penalty.
        """
      )

      write_index(root, "## Terms\n\n- [recall](/beliefs/glossary/recall.md) — #{desc}\n")

      assert {:ok, _} = Glossary.run_checks(root) |> check("repetition")
    end

    test "moderate overlap warns without failing", %{tmp_dir: root} do
      desc =
        "Checking whether a candidate item already exists in a corpus before adding it, " <>
          "to avoid filing duplicate concepts at intake time."

      write_term(
        root,
        "deduplication",
        [type: "concept", title: "deduplication", description: desc],
        """
        # deduplication

        A duplicate concept filed at intake time fragments the corpus: every future related fact lands on one twin arbitrarily and the pair diverges.
        """
      )

      write_index(
        root,
        "## Terms\n\n- [deduplication](/beliefs/glossary/deduplication.md) — #{desc}\n"
      )

      {status, _} = Glossary.run_checks(root) |> check("repetition")
      assert status in [:ok, :warn]
    end
  end

  # ---------------------------------------------------------------------
  # materialize/1
  # ---------------------------------------------------------------------

  describe "materialize/1" do
    test "regenerates the Terms section, preserving the prose above it", %{tmp_dir: root} do
      seed_valid(root)

      write_index(root, """
      ## Terms

      - [backpressure](/beliefs/glossary/backpressure.md) — stale hand-written gloss
      """)

      assert {:written, "beliefs/glossary/index.md"} = Glossary.materialize(root)

      index = File.read!(Path.join(root, "beliefs/glossary/index.md"))
      assert index =~ "Hand-written prose above the listing."

      assert index =~
               "- [actor model](/beliefs/glossary/actor-model.md) — Share-nothing concurrency."

      refute index =~ "stale hand-written gloss"
      assert {:ok, _} = Glossary.run_checks(root) |> check("index sync")
    end

    test "is idempotent once materialized", %{tmp_dir: root} do
      seed_valid(root)
      Glossary.materialize(root)
      assert :unchanged = Glossary.materialize(root)
    end

    test "sorts case-insensitively by title", %{tmp_dir: root} do
      seed_valid(root)

      write_term(
        root,
        "beam",
        [type: "concept", title: "BEAM", description: "The Erlang VM."],
        "# BEAM\n"
      )

      Glossary.materialize(root)
      index = File.read!(Path.join(root, "beliefs/glossary/index.md"))

      actor = :binary.match(index, "[actor model]") |> elem(0)
      beam = :binary.match(index, "[BEAM]") |> elem(0)
      back = :binary.match(index, "[backpressure]") |> elem(0)
      assert actor < back and back < beam
    end
  end
end
