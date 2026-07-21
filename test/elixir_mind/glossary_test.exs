defmodule ElixirMind.GlossaryTest do
  use ExUnit.Case, async: true

  alias ElixirMind.Glossary

  @moduletag :tmp_dir

  # --- fixtures -------------------------------------------------------------

  defp write_term(dir, slug, title, description, body) do
    path = Path.join([dir, "beliefs", "glossary", "#{slug}.md"])
    File.mkdir_p!(Path.dirname(path))

    fm =
      "---\ntype: concept\ntitle: #{title}\n" <>
        if(description == nil, do: "", else: "description: #{description}\n") <>
        "sense: common\n---\n"

    File.write!(path, fm <> "\n# #{title}\n\n" <> body <> "\n")
    path
  end

  defp write_index(dir, body) do
    path = Path.join([dir, "beliefs", "glossary", "index.md"])
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, body)
    path
  end

  # An index whose `## Terms` section is the module's own derivation, so a
  # fixture bundle starts in-sync unless a test deliberately perturbs it.
  defp synced_index(dir, prefix \\ "# Glossary\n\nProse.\n\n") do
    write_index(dir, prefix <> "## Terms\n\n")
    {:written, _} = Glossary.materialize(dir)
  end

  defp status(results, name) do
    {^name, status, _detail} = Enum.find(results, fn {n, _, _} -> n == name end)
    status
  end

  # --- descriptions check ---------------------------------------------------

  describe "descriptions check" do
    test "passes when every term carries a non-empty description", %{tmp_dir: dir} do
      write_term(dir, "actor-model", "actor model", "A concurrency model.", "Expansion.")
      synced_index(dir)

      assert status(Glossary.run_checks(dir), "descriptions") == :ok
    end

    test "fails when a term is missing its description", %{tmp_dir: dir} do
      write_term(dir, "orphan", "orphan", nil, "Body with no lede.")
      synced_index(dir)

      results = Glossary.run_checks(dir)
      assert status(results, "descriptions") == :fail

      {_, :fail, detail} = Enum.find(results, fn {n, _, _} -> n == "descriptions" end)
      assert detail =~ "orphan.md"
    end
  end

  # --- index sync check -----------------------------------------------------

  describe "index sync check" do
    test "passes when `## Terms` is the derivation (sorted, gloss = description)",
         %{tmp_dir: dir} do
      write_term(dir, "beam", "BEAM", "The VM that runs Elixir.", "Expansion.")
      write_term(dir, "actor-model", "actor model", "A concurrency model.", "Expansion.")
      synced_index(dir)

      assert status(Glossary.run_checks(dir), "index sync") == :ok
    end

    test "materialized Terms are title-sorted case-insensitively with verbatim glosses",
         %{tmp_dir: dir} do
      write_term(dir, "beam", "BEAM", "The VM that runs Elixir.", "x")
      write_term(dir, "actor-model", "actor model", "A concurrency model.", "y")
      synced_index(dir)

      terms =
        Path.join([dir, "beliefs", "glossary", "index.md"])
        |> File.read!()
        |> String.split("## Terms\n\n")
        |> List.last()

      assert terms ==
               "- [actor model](/beliefs/glossary/actor-model.md) — A concurrency model.\n" <>
                 "- [BEAM](/beliefs/glossary/beam.md) — The VM that runs Elixir.\n"
    end

    test "fails when a gloss diverges from the description", %{tmp_dir: dir} do
      write_term(dir, "beam", "BEAM", "The VM that runs Elixir.", "x")
      synced_index(dir)

      # Perturb the committed gloss by hand.
      index = Path.join([dir, "beliefs", "glossary", "index.md"])
      drifted = File.read!(index) |> String.replace("The VM that runs Elixir.", "A VM.")
      File.write!(index, drifted)

      assert status(Glossary.run_checks(dir), "index sync") == :fail
    end

    test "fails when the index lacks a `## Terms` section", %{tmp_dir: dir} do
      write_term(dir, "beam", "BEAM", "The VM.", "x")
      write_index(dir, "# Glossary\n\nNo terms heading here.\n")

      assert status(Glossary.run_checks(dir), "index sync") == :fail
    end

    test "materialize preserves the prose above `## Terms` and is idempotent",
         %{tmp_dir: dir} do
      write_term(dir, "beam", "BEAM", "The VM.", "x")
      synced_index(dir, "# Glossary\n\nKeep this intro.\n\n")

      index = Path.join([dir, "beliefs", "glossary", "index.md"])
      assert File.read!(index) =~ "Keep this intro."
      # Already current after synced_index → materialize is a no-op.
      assert Glossary.materialize(dir) == :unchanged
    end
  end

  # --- repetition check -----------------------------------------------------

  describe "repetition check" do
    test "passes when the body only expands the description", %{tmp_dir: dir} do
      write_term(
        dir,
        "actor-model",
        "actor model",
        "A concurrency model in which independent share-nothing processes each own private state and interact only by asynchronous message passing.",
        "Ownership is what makes it a natural idiom for write governance, as in the librarian broker."
      )

      synced_index(dir)

      assert status(Glossary.run_checks(dir), "repetition") == :ok
    end

    test "fails when a body sentence near-restates the description", %{tmp_dir: dir} do
      desc =
        "A concurrency model in which independent share-nothing processes each own private state and interact only by asynchronous message passing."

      write_term(
        dir,
        "actor-model",
        "actor model",
        desc,
        "A concurrency model in which independent share-nothing processes each own private state and interact only by asynchronous message passing."
      )

      synced_index(dir)

      results = Glossary.run_checks(dir)
      assert status(results, "repetition") == :fail

      {_, :fail, detail} = Enum.find(results, fn {n, _, _} -> n == "repetition" end)
      assert detail =~ "actor-model.md"
    end

    test "skips sentences under the content-word floor", %{tmp_dir: dir} do
      # The body restates the description but in fewer than 8 content words.
      write_term(
        dir,
        "recall",
        "recall",
        "The fraction of relevant items a search actually surfaces.",
        "Fraction of relevant items surfaced."
      )

      synced_index(dir)

      assert status(Glossary.run_checks(dir), "repetition") == :ok
    end

    test "excludes the *Seen in:* citation line from the check", %{tmp_dir: dir} do
      desc =
        "A concurrency model in which independent share-nothing processes each own private state and interact only by asynchronous message passing."

      # Body is empty expansion; the citation line echoes description words but
      # must not be scored.
      path = write_term(dir, "actor-model", "actor model", desc, "")

      File.write!(
        path,
        File.read!(path) <>
          "\n*Seen in:* concurrency model independent share-nothing processes private state asynchronous message passing.\n"
      )

      synced_index(dir)

      assert status(Glossary.run_checks(dir), "repetition") == :ok
    end

    test "excludes a generated excerpt-log section from the check", %{tmp_dir: dir} do
      desc =
        "A concurrency model in which independent share-nothing processes each own private state and interact only by asynchronous message passing."

      path = write_term(dir, "actor-model", "actor model", desc, "Genuine expansion prose here.")

      File.write!(
        path,
        File.read!(path) <>
          "\n## Thread excerpts — route-tagged log\n\n" <>
          "A concurrency model in which independent share-nothing processes each own private state and interact only by asynchronous message passing.\n"
      )

      synced_index(dir)

      assert status(Glossary.run_checks(dir), "repetition") == :ok
    end
  end
end
