defmodule SecondBrain.Glossary do
  @moduledoc """
  Machine checks over the glossary's single-overview convention (see the
  [glossary plan](/meta/plans/glossary-single-overview-and-dedup-check.md)).

  Each term file under `beliefs/glossary/` carries one canonical overview: its
  `description` frontmatter, rendered as the entry page's lede and shown
  verbatim as the term's gloss in the index `## Terms` section. The body below
  the lede is expansion-only — it must not restate what the description
  already says.

  Enforcement splits by what has a mechanical oracle, mirroring
  `SecondBrain.RouteTags`:

    * **fail** — a term file missing a non-empty `description`; the index
      `## Terms` section diverging from its re-derivation (`materialize/1`
      regenerates it: one bullet per term, title-sorted case-insensitively,
      gloss = description verbatim).
    * **fail** — a body sentence that near-restates the description:
      normalized content-word containment (lowercase, punctuation stripped,
      stopwords dropped, naive plural stemming; sentences under
      #{8} content words skipped) at or above the fail threshold.
    * **warn** — moderate containment. Semantic redundancy has no exact
      oracle, so the middle band reports without failing, like the
      routing-ledger coverage warning.

  Generated `## Thread excerpts — route-tagged log` sections, *Seen in:* and
  *See also:* lines are excluded from the repetition check — they are
  citations and route-tag materializations, not definition prose.
  """

  alias SecondBrain.Frontmatter

  @glossary_dir "beliefs/glossary"
  @index_rel "beliefs/glossary/index.md"
  @terms_heading "## Terms"
  @excerpt_heading "## Thread excerpts — route-tagged log"

  @fail_threshold 0.72
  @warn_threshold 0.55
  @min_content_words 8

  @stopwords ~w(
    a an the and or but so nor of in on at to for from by with without as
    is are was were be been being it its this that these those which who
    whose whom what when where how why not no than then there here into
    onto over under between each every rather via per one two also can
    may might must should would could shall do does did done has have had
    having you your we our they their them he she his her if else while
    both all any some more most less least very such same other another
    never always only just even still yet about after before against
  )

  @doc "Repo-relative path of the glossary index."
  def index_path, do: @index_rel

  @doc """
  Run all glossary checks. Returns a list of `{name, :ok | :warn | :fail,
  detail}` tuples, like `SecondBrain.RouteTags.run_checks/1`.
  """
  @spec run_checks(String.t()) :: [{String.t(), :ok | :warn | :fail, String.t()}]
  def run_checks(root \\ File.cwd!()) do
    entries = scan(root)

    [
      description_check(entries),
      index_sync_check(root, entries),
      repetition_check(entries)
    ]
  end

  @doc """
  Regenerate the index's `## Terms` section from the term files (title-sorted
  case-insensitively, gloss = `description` verbatim), preserving the prose
  above the heading. Returns `{:written, path}` or `:unchanged`.
  """
  @spec materialize(String.t()) :: {:written, String.t()} | :unchanged
  def materialize(root \\ File.cwd!()) do
    index = Path.join(root, @index_rel)
    current = File.read!(index)

    prefix =
      case String.split(current, @terms_heading, parts: 2) do
        [head, _] -> head
        [_] -> String.trim_trailing(current) <> "\n\n"
      end

    next = prefix <> derived_terms_section(scan(root))

    if next == current do
      :unchanged
    else
      File.write!(index, next)
      {:written, @index_rel}
    end
  end

  # --- scanning -------------------------------------------------------------

  defp scan(root) do
    root
    |> Path.join(@glossary_dir)
    |> Path.join("*.md")
    |> Path.wildcard()
    |> Enum.reject(&(Path.basename(&1) == "index.md"))
    |> Enum.sort()
    |> Enum.map(fn path ->
      rel = Path.relative_to(path, root)
      slug = Path.basename(path, ".md")

      case Frontmatter.parse(File.read!(path)) do
        {:ok, %{frontmatter: fm, body: body}} ->
          %{
            path: rel,
            slug: slug,
            title: fm["title"] || slug,
            description: fm["description"],
            body: body,
            parsed: true
          }

        {:error, _} ->
          # Tolerant consumer: brain.verify owns frontmatter conformance.
          %{path: rel, slug: slug, title: slug, description: nil, body: "", parsed: false}
      end
    end)
  end

  # --- check 1: every term carries the canonical overview --------------------

  defp description_check(entries) do
    missing =
      for e <- entries, e.parsed, e.description in [nil, ""] or not is_binary(e.description) do
        e.path
      end

    case missing do
      [] ->
        {"descriptions", :ok, "every term file carries a non-empty `description`"}

      paths ->
        {"descriptions", :fail,
         "term file(s) missing a `description` (the canonical overview):\n    " <>
           Enum.join(paths, "\n    ")}
    end
  end

  # --- check 2: index Terms section == its re-derivation ---------------------

  defp index_sync_check(root, entries) do
    index = Path.join(root, @index_rel)

    with true <- File.exists?(index),
         current = File.read!(index),
         [_, actual] <- String.split(current, @terms_heading, parts: 2) do
      if String.trim_trailing(@terms_heading <> actual) ==
           String.trim_trailing(derived_terms_section(entries)) do
        {"index sync", :ok, "`## Terms` matches its re-derivation from the term files"}
      else
        {"index sync", :fail,
         "#{@index_rel}: `## Terms` diverges from the term files' title/description " <>
           "(order, coverage, or gloss text) — run `mix brain.glossary --materialize`"}
      end
    else
      false -> {"index sync", :fail, "#{@index_rel} is missing"}
      [_] -> {"index sync", :fail, "#{@index_rel} has no `#{@terms_heading}` section"}
    end
  end

  defp derived_terms_section(entries) do
    bullets =
      entries
      |> Enum.sort_by(&String.downcase(&1.title))
      |> Enum.map(fn e ->
        gloss =
          case e.description do
            d when is_binary(d) and d != "" -> " — " <> d
            _ -> ""
          end

        "- [#{e.title}](/#{@glossary_dir}/#{e.slug}.md)#{gloss}"
      end)

    @terms_heading <> "\n\n" <> Enum.join(bullets, "\n") <> "\n"
  end

  # --- check 3: bodies expand the description, never restate it --------------

  defp repetition_check(entries) do
    findings =
      entries
      |> Enum.filter(&(&1.parsed and is_binary(&1.description)))
      |> Enum.flat_map(&entry_findings/1)

    fails = for {:fail, msg} <- findings, do: msg
    warns = for {:warn, msg} <- findings, do: msg

    cond do
      fails != [] ->
        {"repetition", :fail,
         "body sentence(s) near-restate the entry's `description` (the lede already " <>
           "says this — keep only expansion):\n    " <> Enum.join(fails, "\n    ")}

      warns != [] ->
        {"repetition", :warn,
         "body sentence(s) overlap the `description` heavily (editorial — worth a " <>
           "look):\n    " <> Enum.join(warns, "\n    ")}

      true ->
        {"repetition", :ok, "no body sentence restates its entry's `description`"}
    end
  end

  defp entry_findings(entry) do
    desc_words = content_words(entry.description)

    entry.body
    |> prose()
    |> sentences()
    |> Enum.flat_map(fn sentence ->
      words = content_words(sentence)

      if MapSet.size(words) < @min_content_words do
        []
      else
        shared = MapSet.intersection(words, desc_words) |> MapSet.size()
        containment = shared / MapSet.size(words)

        cond do
          containment >= @fail_threshold ->
            [{:fail, "#{entry.path}: #{format_pct(containment)} — #{excerpt(sentence)}"}]

          containment >= @warn_threshold ->
            [{:warn, "#{entry.path}: #{format_pct(containment)} — #{excerpt(sentence)}"}]

          true ->
            []
        end
      end
    end)
  end

  # Definition prose only: everything after the `# term` heading, up to any
  # generated excerpt-log section, minus citation lines.
  defp prose(body) do
    body
    |> String.split(@excerpt_heading, parts: 2)
    |> hd()
    |> String.split("\n")
    |> Enum.reject(fn line ->
      trimmed = String.trim(line)

      String.starts_with?(trimmed, "#") or
        String.starts_with?(trimmed, "*Seen in:*") or
        String.starts_with?(trimmed, "*See also:*")
    end)
    |> Enum.join("\n")
  end

  defp sentences(text) do
    text
    |> String.replace(~r/\[([^\]]*)\]\([^)]*\)/, "\\1")
    |> String.replace(~r/\be\.g\.|\bi\.e\.|\bcf\.|\bvs\.|\ba\.k\.a\./, " ")
    |> String.split(~r/(?<=[.!?;])\s+|\n\n+/, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp content_words(text) do
    text
    |> String.downcase()
    |> String.replace(~r/\[([^\]]*)\]\([^)]*\)/, "\\1")
    |> String.replace(~r/[^a-z0-9]+/, " ")
    |> String.split()
    |> Enum.reject(&(&1 in @stopwords))
    |> Enum.map(&stem/1)
    |> MapSet.new()
  end

  # Naive plural stemming — enough to match "owns"/"own", "actors"/"actor".
  defp stem(word) do
    if String.length(word) > 3 and String.ends_with?(word, "s") and
         not String.ends_with?(word, "ss") do
      String.slice(word, 0..-2//1)
    else
      word
    end
  end

  defp format_pct(x), do: "#{round(x * 100)}% contained"

  defp excerpt(sentence) do
    flat = sentence |> String.replace(~r/\s+/, " ") |> String.trim()
    if String.length(flat) > 90, do: String.slice(flat, 0, 87) <> "…", else: flat
  end
end
