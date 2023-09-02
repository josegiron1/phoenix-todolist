defmodule Todo.Repo.Migrations.CreateTodo do
  use Ecto.Migration

  def change do
    alter table(:todo) do

      timestamps()
    end

    create index(:todo, [:user_id])
  end
end
