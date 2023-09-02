defmodule Todo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:todo) do
      add :task, :string
      add :completed, :boolean

    end
  end
end
