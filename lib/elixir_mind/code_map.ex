defmodule ElixirMind.CodeMap do
  @moduledoc """
  Compiles `meta/code-map.md` — the code glossary of module, function, and type
  intent for the `elixir_mind` tooling.

  The tooling (`lib/`, the `mix brain.*` tasks) sits *alongside* the knowledge
  bundle, not inside it: it carries no `em:` id and the site excludes `lib/`, so
  the code has no page and no registry entry. This module gives it the one thing
  the bundle documents get for free — a browsable statement of intent — by
  compiling it from the docstrings already in the source.

  Like `CLAUDE.md` (via `ElixirMind.Contract`) and `meta/registry.md` (via
  `ElixirMind.Registry`), the output is a **generated artifact**: the `@moduledoc`
  / `@doc` / `@typedoc` in each module are the source of truth, `render/0` compiles
  them, and `mix brain.codemap --check` fails in CI if the checked-in file drifts.
  Extraction uses `Code.fetch_docs/1` (standard library), so the whole thing stays
  dependency-free and runs offline — no ExDoc, no second doc site.

  Scope: every module compiled into the `:elixir_mind` application that carries a
  *visible* `@moduledoc`. Modules marked `@moduledoc false` (internal structs like
  `ElixirMind.Registry.Entry`, the Mix project) are intentionally omitted, exactly
  as they are from ExDoc — documenting them is a docstring-enrichment decision, not
  a code-map one.
  """

  @output "meta/code-map.md"

  @doc "Path of the compiled code map, relative to repo root."
  def output_path, do: @output

  @doc """
  The documented modules, split into `{library, tasks}` — `ElixirMind.*` modules
  and the `mix brain.*` task modules respectively — each sorted by name, each
  carrying a visible `@moduledoc`.
  """
  def modules do
    Application.load(:elixir_mind)

    (Application.spec(:elixir_mind, :modules) || [])
    |> Enum.map(&{&1, Code.fetch_docs(&1)})
    |> Enum.filter(fn {_mod, docs} -> visible_moduledoc?(docs) end)
    |> Enum.map(fn {mod, docs} -> {mod, docs} end)
    |> Enum.sort_by(fn {mod, _} -> inspect(mod) end)
    |> Enum.split_with(fn {mod, _} -> not task?(mod) end)
  end

  @doc "Render the compiled code map markdown."
  def render do
    {library, tasks} = modules()

    """
    #{banner()}

    # Code map — module, function & type intent

    A generated glossary of the `elixir_mind` tooling: every module compiled into
    the application, its purpose (`@moduledoc`), its public functions, and its
    declared types. The tooling is not part of the knowledge bundle — it has no
    `em:` id and no site page — so this map is where its intent is browsable.

    Source of truth is the docstrings in `lib/`; this file is compiled from them
    (`mix brain.codemap`) and checked for drift in CI (`mix brain.codemap --check`),
    on the same generated-artifact discipline as `CLAUDE.md` and
    [`meta/registry.md`](/meta/registry.md). To change an entry, edit the module's
    `@moduledoc`/`@doc`/`@typedoc` and regenerate — never edit this file by hand.

    ## Library — `ElixirMind.*`

    #{render_group(library)}
    ## Mix tasks — `mix brain.*`

    #{render_group(tasks)}
    """
  end

  @doc "Render and write the code map. Returns the output path."
  def write(root \\ File.cwd!()) do
    path = Path.join(root, @output)
    File.write!(path, render())
    path
  end

  @doc "Check the on-disk code map matches a fresh render."
  def check(root \\ File.cwd!()) do
    path = Path.join(root, @output)
    actual = if File.exists?(path), do: File.read!(path), else: ""
    if render() == actual, do: :ok, else: {:stale, @output}
  end

  # --- rendering -----------------------------------------------------------

  defp render_group(mods), do: Enum.map_join(mods, "\n", &render_module/1)

  defp render_module({mod, {:docs_v1, _, _, _, mod_doc, _, docs}}) do
    functions = entries(docs, :function)
    types = entries(docs, :type)

    """
    ### `#{inspect(mod)}`

    `#{source_path(mod)}`

    #{text(mod_doc)}

    #{render_functions(functions)}#{render_types(types)}
    """
  end

  defp render_functions([]), do: ""

  defp render_functions(functions) do
    "**Functions**\n\n" <>
      Enum.map_join(functions, "\n", fn {name, arity, doc} ->
        "- `#{name}/#{arity}`#{summary(doc)}"
      end) <> "\n"
  end

  defp render_types([]), do: ""

  defp render_types(types) do
    "\n**Types**\n\n" <>
      Enum.map_join(types, "\n", fn {name, arity, doc} ->
        "- `#{name}/#{arity}`#{summary(doc)}"
      end) <> "\n"
  end

  # `{{kind, name, arity}, anno, sig, doc, meta}` tuples of one kind, sorted,
  # with `@doc false` (`:hidden`) entries dropped.
  defp entries(docs, kind) do
    docs
    |> Enum.filter(fn {{k, _, _}, _, _, doc, _} -> k == kind and doc != :hidden end)
    |> Enum.map(fn {{_, name, arity}, _, _, doc, _} -> {name, arity, doc} end)
    |> Enum.sort()
  end

  defp visible_moduledoc?({:docs_v1, _, _, _, mod_doc, _, _}), do: match?(%{}, mod_doc)
  defp visible_moduledoc?(_), do: false

  # First paragraph of a docstring, flattened to a single line, prefixed with the
  # em-dash separator. Undocumented (`:none`) entries render bare.
  defp summary(:none), do: ""

  defp summary(doc) do
    " — " <>
      (doc
       |> text()
       |> String.split("\n\n", parts: 2)
       |> hd()
       |> String.replace(~r/\s+/, " ")
       |> String.trim())
  end

  defp text(%{} = doc), do: doc |> Map.get("en", "") |> String.trim()
  defp text(_), do: ""

  # Module → repo-relative source path from compile metadata. Correct for both
  # standalone modules and inline submodules (e.g. a struct defined inside its
  # parent's file), and deterministic: the source is always under the repo root
  # the task runs from, so `relative_to/2` yields the same `lib/…` path everywhere.
  defp source_path(mod) do
    mod.module_info(:compile)[:source]
    |> to_string()
    |> Path.relative_to(File.cwd!())
  end

  defp task?(mod), do: match?(["Mix", "Tasks", "Brain", _], Module.split(mod))

  defp banner do
    """
    <!--
      GENERATED FILE — do not edit by hand.
      Source of truth: the @moduledoc/@doc/@typedoc in each lib/ module.
      Regenerate:      mix brain.codemap
      Verify (CI):     mix brain.codemap --check
    -->\
    """
  end
end
