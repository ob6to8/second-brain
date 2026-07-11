defmodule SecondBrain.SessionInitTest do
  use ExUnit.Case, async: true

  alias SecondBrain.SessionInit

  @moduletag :tmp_dir

  defp write_doc(dir, rel_path, fields, body \\ "Body.") do
    path = Path.join(dir, rel_path)
    File.mkdir_p!(Path.dirname(path))
    fm = Enum.map_join(fields, "\n", fn {k, v} -> "#{k}: #{v}" end)
    File.write!(path, "---\n#{fm}\n---\n#{body}\n")
  end

  defp write_thread(dir, rel_path, rows) do
    table =
      [
        "| Topic | State | Routed to | Dangling |",
        "|---|---|---|---|"
        | Enum.map(rows, fn {t, s, r, d} -> "| #{t} | #{s} | #{r} | #{d} |" end)
      ]
      |> Enum.join("\n")

    body = "Narrative.\n\n## Routing\n\n#{table}\n\n## User\n\nHi.\n"
    write_doc(dir, rel_path, [type: "reference", title: "thread"], body)
  end

  test "collects open issues, todos, active plans, and pending strands", %{tmp_dir: dir} do
    write_doc(dir, "meta/issues/broken.md",
      type: "issue",
      title: "Broken thing",
      description: "It broke.",
      status: "open",
      timestamp: "2026-07-09"
    )

    write_doc(dir, "meta/todos/do-thing.md",
      type: "todo",
      title: "Do the thing",
      description: "Thing is done.",
      status: "open",
      timestamp: "2026-07-09"
    )

    write_doc(dir, "meta/todos/done-thing.md",
      type: "todo",
      title: "Old thing",
      status: "done",
      timestamp: "2026-07-08"
    )

    write_doc(dir, "meta/issues/fixed.md",
      type: "issue",
      title: "Fixed thing",
      status: "resolved",
      timestamp: "2026-07-08"
    )

    write_doc(dir, "meta/plans/next.md",
      type: "plan",
      title: "Next plan",
      description: "Do it.",
      status: "proposed",
      timestamp: "2026-07-09"
    )

    write_doc(dir, "meta/plans/shipped.md",
      type: "plan",
      title: "Shipped plan",
      status: "done",
      timestamp: "2026-07-01"
    )

    write_thread(dir, "meta/threads/2026-07-09-a.md", [
      {"Live strand", "open", "`unrouted`", "What next?"},
      {"Finished strand", "closed", "`unrouted`", "-"},
      {"Deferred strand", "closed", "`unrouted`", "Tier-1 not built"}
    ])

    assert [%{title: "Broken thing"}] = SessionInit.open_issues(dir)
    assert [%{title: "Do the thing"}] = SessionInit.open_todos(dir)
    assert [%{title: "Next plan", status: "proposed"}] = SessionInit.active_plans(dir)

    strands = SessionInit.dangling_strands(dir)
    assert Enum.map(strands, & &1.topic) == ["Live strand", "Deferred strand"]
  end

  test "report ranks issues above todos above strands", %{tmp_dir: dir} do
    write_doc(dir, "meta/issues/broken.md",
      type: "issue",
      title: "Broken thing",
      status: "open",
      timestamp: "2026-07-09"
    )

    write_doc(dir, "meta/todos/do-thing.md",
      type: "todo",
      title: "Do the thing",
      status: "open",
      timestamp: "2026-07-09"
    )

    write_doc(dir, "meta/plans/next.md",
      type: "plan",
      title: "Next plan",
      status: "proposed",
      timestamp: "2026-07-09"
    )

    write_thread(dir, "meta/threads/2026-07-09-a.md", [
      {"Live strand", "open", "`unrouted`", "What next?"},
      {"Same matter as the issue", "open", "[issue](/meta/issues/broken.md)", "gate?"}
    ])

    report = SessionInit.report(dir)

    assert report =~ "## Open issues (1)"
    assert report =~ "## Open todos (1)"
    assert report =~ "## Active plans (1)"
    assert report =~ "## Dangling strands (from thread ledgers) (2)"

    [_, priorities] = String.split(report, "## Heuristic top-3 priorities")

    assert [i1, i2, i3] =
             Regex.run(~r/1\. (.*)\n.*\n2\. (.*)\n.*\n3\. (.*)\n/, priorities,
               capture: :all_but_first
             )

    assert i1 =~ "Broken thing"
    assert i2 =~ "Do the thing"
    assert i3 =~ "Live strand"
    assert report =~ "**Agent note:**"
  end

  test "empty bundle reports clear state", %{tmp_dir: dir} do
    File.mkdir_p!(Path.join(dir, "meta"))
    report = SessionInit.report(dir)

    assert report =~ "## Open issues (0)"
    assert report =~ "No open work found"
  end
end
