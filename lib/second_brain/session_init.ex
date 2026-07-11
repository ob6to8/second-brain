defmodule SecondBrain.SessionInit do
  @moduledoc """
  The session-init digest: a point-in-time scan of the brain's open work,
  rendered as markdown for injection into a fresh session's context (the
  SessionStart hook runs `mix brain.session_init` and echoes the output).

  Four sources, all already maintained by existing policy:

    * **Open issues** — `meta/issues/*.md` with `status: open`.
    * **Open todos** — `meta/todos/*.md` with `status: open`.
    * **Active plans** — `meta/plans/*.md` with `status` in
      `proposed` / `accepted` / `in-progress`.
    * **Dangling strands** — routing-ledger rows in `meta/threads/*.md` whose
      state is `open`/`paused`, or whose Dangling column carries a question
      (a `closed` row can still leave deferred work dangling).

  The digest ends with a heuristic top-3 priority ranking (issues, then
  in-flight plans, then open todos, then accepted plans, then open strands,
  then paused strands and leftover dangling questions, then proposed plans;
  newer first within a class) and an
  agent note asking the session agent to open the thread with its own
  appraisal, using the heuristic as a starting point — the script ranks, the
  agent judges.

  An issue/todo/plan may carry an explicit `priority: <integer>` frontmatter
  key (1 = most urgent). Flagged items rank above every heuristic class,
  ordered among themselves by the integer — the operator's escape hatch when
  the class weights get it wrong. Strands come from ledger rows, which have
  no frontmatter, so they cannot be flagged.

  Tolerant consumer per OKF conformance: unparseable files and malformed
  ledger rows are skipped, never fatal.
  """

  alias SecondBrain.Frontmatter

  @active_plan_statuses ~w(proposed accepted in-progress)
  @topic_max_chars 160

  # Lower weight = higher priority. Newer items win ties within a class.
  @weights %{
    issue: 0,
    plan_in_progress: 1,
    todo: 2,
    plan_accepted: 3,
    strand_open: 4,
    strand_paused: 5,
    strand_dangling: 6,
    plan_proposed: 7
  }

  @doc "Render the full session-init digest for the bundle rooted at `root`."
  @spec report(String.t()) :: String.t()
  def report(root \\ File.cwd!()) do
    issues = open_issues(root)
    todos = open_todos(root)
    plans = active_plans(root)
    strands = dangling_strands(root)

    """
    # Session init — open work digest

    Compiled by `mix brain.session_init` from `meta/issues/`, `meta/todos/`,
    `meta/plans/`, and the routing ledgers under `meta/threads/`.

    #{section("Open issues", Enum.map(issues, &issue_line/1))}
    #{section("Open todos", Enum.map(todos, &issue_line/1))}
    #{section("Active plans", Enum.map(plans, &plan_line/1))}
    #{section("Dangling strands (from thread ledgers)", Enum.map(strands, &strand_line/1))}
    #{priorities_section(issues, todos, plans, strands)}
    > **Agent note:** open this session by stating your top-3 priority appraisal
    > for the operator — start from the heuristic ranking above, adjust it with
    > judgment, and say why. Then address the operator's request.
    """
  end

  # --- open issues ----------------------------------------------------------

  @doc "Open issues under meta/issues, newest first."
  def open_issues(root) do
    root
    |> docs_in("meta/issues")
    |> Enum.filter(&(status(&1) == "open"))
    |> sort_newest_first()
  end

  # --- open todos -----------------------------------------------------------

  @doc "Open todos under meta/todos, newest first."
  def open_todos(root) do
    root
    |> docs_in("meta/todos")
    |> Enum.filter(&(status(&1) == "open"))
    |> sort_newest_first()
  end

  # --- active plans ---------------------------------------------------------

  @doc "Plans under meta/plans that are proposed/accepted/in-progress, newest first."
  def active_plans(root) do
    root
    |> docs_in("meta/plans")
    |> Enum.filter(&(status(&1) in @active_plan_statuses))
    |> sort_newest_first()
  end

  # --- dangling strands -----------------------------------------------------

  @doc """
  Routing-ledger rows across meta/threads that still carry work: state
  `open`/`paused`, or a non-`-` Dangling cell. Newest thread first.
  """
  def dangling_strands(root) do
    root
    |> docs_in("meta/threads")
    |> Enum.flat_map(fn doc ->
      doc.body
      |> routing_rows()
      |> Enum.filter(&strand_pending?/1)
      |> Enum.map(&Map.put(&1, :thread, doc.rel_path))
    end)
    |> Enum.sort_by(& &1.thread, :desc)
  end

  defp strand_pending?(row) do
    row.state in ~w(open paused) or row.dangling not in ["-", ""]
  end

  defp routing_rows(body) do
    body
    |> routing_section()
    |> Enum.filter(&String.starts_with?(String.trim(&1), "|"))
    |> Enum.flat_map(fn line ->
      cells =
        line
        |> String.trim()
        |> String.trim_leading("|")
        |> String.trim_trailing("|")
        |> String.split("|")
        |> Enum.map(&String.trim/1)

      case cells do
        ["Topic" | _] ->
          []

        [<<":", _::binary>> | _] ->
          []

        [<<"-", _::binary>>, _, _, _] ->
          []

        [topic, state, routed_to, dangling] ->
          [
            %{
              topic: topic,
              state: String.downcase(state),
              routed_to: routed_to,
              dangling: dangling
            }
          ]

        _ ->
          []
      end
    end)
  end

  defp routing_section(body) do
    body
    |> String.split("\n")
    |> Enum.drop_while(&(String.trim(&1) != "## Routing"))
    |> Enum.drop(1)
    |> Enum.take_while(&(not String.starts_with?(&1, "## ")))
  end

  # --- shared scanning ------------------------------------------------------

  defp docs_in(root, rel_dir) do
    dir = Path.join(root, rel_dir)

    dir
    |> Path.join("*.md")
    |> Path.wildcard()
    |> Enum.reject(&(Path.basename(&1) in ~w(index.md log.md)))
    |> Enum.flat_map(fn path ->
      case File.read(path) |> parse() do
        {:ok, %{frontmatter: fm, body: body}} ->
          [
            %{
              rel_path: Path.relative_to(path, root),
              title: fm["title"] || Path.basename(path, ".md"),
              description: fm["description"],
              status: fm["status"],
              priority: to_priority(fm["priority"]),
              timestamp: to_string(fm["timestamp"] || ""),
              body: body
            }
          ]

        _ ->
          []
      end
    end)
  end

  defp parse({:ok, content}), do: Frontmatter.parse(content)
  defp parse(error), do: error

  defp status(doc), do: doc.status && String.downcase(to_string(doc.status))

  defp to_priority(p) when is_integer(p), do: p

  defp to_priority(p) when is_binary(p) do
    case Integer.parse(String.trim(p)) do
      {n, ""} -> n
      _ -> nil
    end
  end

  defp to_priority(_), do: nil

  defp sort_newest_first(docs),
    do: Enum.sort_by(docs, &{&1.timestamp, &1.rel_path}, :desc)

  # --- rendering ------------------------------------------------------------

  defp section(title, []), do: "## #{title} (0)\n\n_(none)_\n"
  defp section(title, lines), do: "## #{title} (#{length(lines)})\n\n#{Enum.join(lines, "\n")}\n"

  defp issue_line(doc),
    do: "- **#{doc.title}** — #{doc.description || "no description"} (`/#{doc.rel_path}`)"

  defp plan_line(doc),
    do:
      "- **#{doc.title}** (`#{doc.status}`) — #{doc.description || "no description"} (`/#{doc.rel_path}`)"

  defp strand_line(row) do
    dangling = if row.dangling in ["-", ""], do: "", else: " — dangling: #{row.dangling}"
    "- `#{row.state}` #{truncate(row.topic)}#{dangling} (`/#{row.thread}`)"
  end

  defp truncate(text) do
    if String.length(text) > @topic_max_chars,
      do: String.slice(text, 0, @topic_max_chars) <> "…",
      else: text
  end

  # --- heuristic priorities -------------------------------------------------

  defp priorities_section(issues, todos, plans, strands) do
    # Each source list is already newest-first; Enum.sort_by/2 is stable, so
    # sorting on weight alone keeps that recency order within a class. A strand
    # whose ledger routed to an already-picked doc is the same matter — skip it.
    picks =
      candidates(issues, todos, plans, strands)
      |> Enum.sort_by(&sort_key/1)
      |> Enum.reduce([], fn c, acc ->
        if Enum.any?(acc, &(&1.path && String.contains?(c.routed_to || "", &1.path))),
          do: acc,
          else: acc ++ [c]
      end)
      |> Enum.take(3)

    case picks do
      [] ->
        "## Heuristic top-3 priorities\n\nNo open work found — issues, plans, and ledgers are all clear.\n"

      picks ->
        lines =
          picks
          |> Enum.with_index(1)
          |> Enum.map(fn {c, i} -> "#{i}. #{c.label}\n   — #{why(c)}" end)

        "## Heuristic top-3 priorities\n\n#{Enum.join(lines, "\n")}\n"
    end
  end

  # Operator-flagged items (integer `priority:` frontmatter) outrank every
  # heuristic class, ordered among themselves by the integer.
  defp sort_key(%{priority: p}) when is_integer(p), do: {0, p}
  defp sort_key(c), do: {1, @weights[c.class]}

  defp candidates(issues, todos, plans, strands) do
    issue_cands =
      Enum.map(issues, fn d ->
        %{
          class: :issue,
          path: d.rel_path,
          priority: d.priority,
          routed_to: nil,
          label: "**#{d.title}** (`/#{d.rel_path}`)"
        }
      end)

    todo_cands =
      Enum.map(todos, fn d ->
        %{
          class: :todo,
          path: d.rel_path,
          priority: d.priority,
          routed_to: nil,
          label: "**#{d.title}** (`/#{d.rel_path}`)"
        }
      end)

    plan_cands =
      Enum.map(plans, fn d ->
        class =
          case status(d) do
            "in-progress" -> :plan_in_progress
            "accepted" -> :plan_accepted
            _ -> :plan_proposed
          end

        %{
          class: class,
          path: d.rel_path,
          priority: d.priority,
          routed_to: nil,
          label: "**#{d.title}** (`/#{d.rel_path}`)"
        }
      end)

    strand_cands =
      Enum.map(strands, fn row ->
        class =
          case row.state do
            "open" -> :strand_open
            "paused" -> :strand_paused
            _ -> :strand_dangling
          end

        %{
          class: class,
          path: nil,
          priority: nil,
          routed_to: row.routed_to,
          label: "#{truncate(row.topic)} (`/#{row.thread}`)"
        }
      end)

    issue_cands ++ todo_cands ++ plan_cands ++ strand_cands
  end

  defp why(%{priority: p}) when is_integer(p),
    do: "operator-flagged `priority: #{p}` — pinned above the heuristic classes"

  defp why(%{class: class}), do: why(class)

  defp why(:issue), do: "open operational issue — tracked problems outrank new work"
  defp why(:todo), do: "open todo — an explicitly recorded task awaiting completion"
  defp why(:plan_in_progress), do: "plan already in progress — finish what is started"
  defp why(:plan_accepted), do: "accepted plan awaiting execution"
  defp why(:strand_open), do: "open thread strand — live work left unrouted or unresolved"
  defp why(:strand_paused), do: "paused strand blocked on a dangling question"
  defp why(:strand_dangling), do: "closed strand that left deferred work dangling"
  defp why(:plan_proposed), do: "proposed plan awaiting operator decision"
end
