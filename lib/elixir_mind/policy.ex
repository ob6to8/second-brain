defmodule ElixirMind.Policy do
  @moduledoc """
  A governance policy: a `type: policy` OKF document under `meta/policy/`. Policies
  are the *source of truth* for the operating contract; `CLAUDE.md` is compiled from
  them (see `ElixirMind.Contract`).

  Each policy declares which contract `section` it renders into and its `order`
  within that section.
  """

  @enforce_keys [:id, :title, :section, :order, :body]
  defstruct [:id, :title, :section, :order, :body, :description, :status, path: nil]

  @type t :: %__MODULE__{
          id: String.t(),
          title: String.t(),
          section: String.t(),
          order: integer,
          body: String.t(),
          description: String.t() | nil,
          status: String.t() | nil,
          path: String.t() | nil
        }

  @policy_dir "meta/policy"

  @doc "Directory (relative to repo root) holding policy documents."
  def dir, do: @policy_dir

  @doc """
  Load every active policy document, sorted by `(section, order, id)`.
  Raises if a document is missing a required field.
  """
  @spec load_all(String.t()) :: [t]
  def load_all(root \\ File.cwd!()) do
    root
    |> Path.join(@policy_dir)
    |> Path.join("*.md")
    |> Path.wildcard()
    |> Enum.reject(&(Path.basename(&1) == "index.md"))
    |> Enum.map(&load!/1)
    |> Enum.reject(&(&1.status == "superseded"))
    |> Enum.sort_by(&{&1.section, &1.order, &1.id})
  end

  @doc "Load and validate a single policy document."
  @spec load!(String.t()) :: t
  def load!(path) do
    %{frontmatter: fm, body: body} = path |> File.read!() |> ElixirMind.Frontmatter.parse!()

    id = Path.basename(path, ".md")

    unless fm["type"] == "policy" do
      raise ArgumentError, "#{path}: expected `type: policy`, got #{inspect(fm["type"])}"
    end

    %__MODULE__{
      id: id,
      title: require_field(fm, "title", path),
      section: require_field(fm, "section", path),
      order: fetch_order(fm, path),
      description: fm["description"],
      status: fm["status"] || "active",
      body: String.trim(body),
      path: path
    }
  end

  defp require_field(fm, key, path) do
    case fm[key] do
      nil -> raise ArgumentError, "#{path}: missing required frontmatter field `#{key}`"
      "" -> raise ArgumentError, "#{path}: empty frontmatter field `#{key}`"
      value -> value
    end
  end

  defp fetch_order(fm, path) do
    case fm["order"] do
      n when is_integer(n) -> n
      other -> raise ArgumentError, "#{path}: `order` must be an integer, got #{inspect(other)}"
    end
  end
end
