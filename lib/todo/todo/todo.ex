defmodule Todo.Todo.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo" do
    field :completed, :boolean, default: false
    field :task, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:task, :completed, :user_id])
    |> validate_required([:task, :completed, :user_id])
  end

  def task_completed(todo, attrs) do
    todo
    |> cast(attrs, [:id, :completed, :user_id])
    |> validate_required([:id, :completed, :user_id])
  end

end
