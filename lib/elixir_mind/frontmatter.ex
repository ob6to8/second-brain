defmodule ElixirMind.Frontmatter do
  @moduledoc """
  Parser for the small YAML-frontmatter subset used by OKF concept documents in
  this bundle. Deliberately dependency-free: it handles scalars (string, integer,
  boolean), quoted strings, inline `[a, b, c]` lists, and **one level of nested
  block maps** (a `key:` with no value whose children are indented `k: v` pairs —
  the shape of `attribution:` and `lineage:` blocks) — which is everything the
  bundle's frontmatter uses. It is a tolerant *consumer* per OKF §5: unknown keys
  are preserved as strings.

  A document is `---\\n<yaml>\\n---\\n<body>`. `parse/1` returns
  `{:ok, %{frontmatter: map, body: string}}` or `{:error, reason}`.
  """

  @doc "Parse a full document (frontmatter + body)."
  @spec parse(binary) :: {:ok, %{frontmatter: map, body: binary}} | {:error, term}
  def parse(content) when is_binary(content) do
    case split(content) do
      {:ok, yaml, body} -> {:ok, %{frontmatter: parse_yaml(yaml), body: body}}
      {:error, _} = err -> err
    end
  end

  @doc "Like `parse/1` but raises on malformed input."
  @spec parse!(binary) :: %{frontmatter: map, body: binary}
  def parse!(content) do
    case parse(content) do
      {:ok, result} -> result
      {:error, reason} -> raise ArgumentError, "invalid frontmatter document: #{inspect(reason)}"
    end
  end

  # --- splitting -----------------------------------------------------------

  defp split(content) do
    normalized = String.replace(content, "\r\n", "\n")

    case normalized do
      "---\n" <> rest -> split_after_open(rest)
      _ -> {:error, :missing_frontmatter}
    end
  end

  defp split_after_open(rest) do
    case String.split(rest, "\n---\n", parts: 2) do
      [yaml, body] ->
        {:ok, yaml, body}

      # frontmatter block that ends the file with a trailing `\n---`
      [only] ->
        case String.split(only, "\n---", parts: 2) do
          [yaml, body] -> {:ok, yaml, String.trim_leading(body, "\n")}
          _ -> {:error, :unterminated_frontmatter}
        end
    end
  end

  # --- yaml subset ---------------------------------------------------------

  defp parse_yaml(yaml) do
    {acc, _open} =
      yaml
      |> String.split("\n")
      |> Enum.reduce({%{}, nil}, fn line, {acc, open} ->
        trimmed = String.trim(line)

        cond do
          trimmed == "" -> {acc, open}
          String.starts_with?(trimmed, "#") -> {acc, open}
          indent_of(line) > 0 and open != nil -> {put_nested(acc, open, trimmed), open}
          true -> put_pair(acc, trimmed)
        end
      end)

    acc
  end

  defp indent_of(line), do: String.length(line) - String.length(String.trim_leading(line))

  # A top-level `key:` with no value opens a (potential) nested block map; it
  # parses as `""` unless indented children follow, preserving the flat
  # behavior for genuinely empty values.
  defp put_pair(acc, line) do
    case String.split(line, ":", parts: 2) do
      [key, ""] -> {Map.put(acc, String.trim(key), ""), String.trim(key)}
      [key, raw] -> {Map.put(acc, String.trim(key), coerce(String.trim(raw))), nil}
      [_key] -> {acc, nil}
    end
  end

  defp put_nested(acc, open, trimmed) do
    case String.split(trimmed, ":", parts: 2) do
      [key, raw] ->
        nested =
          case acc[open] do
            %{} = map -> map
            _ -> %{}
          end

        Map.put(acc, open, Map.put(nested, String.trim(key), coerce(String.trim(raw))))

      [_no_pair] ->
        acc
    end
  end

  defp coerce("true"), do: true
  defp coerce("false"), do: false

  defp coerce("[" <> _ = list) do
    list
    |> String.trim_leading("[")
    |> String.trim_trailing("]")
    |> String.split(",")
    |> Enum.map(&unquote_scalar(String.trim(&1)))
    |> Enum.reject(&(&1 == ""))
  end

  defp coerce(value) do
    case Integer.parse(value) do
      {int, ""} -> int
      _ -> unquote_scalar(value)
    end
  end

  defp unquote_scalar(<<?", rest::binary>>), do: String.trim_trailing(rest, "\"")
  defp unquote_scalar(<<?', rest::binary>>), do: String.trim_trailing(rest, "'")
  defp unquote_scalar(value), do: value
end
