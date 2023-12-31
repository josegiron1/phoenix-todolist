defmodule Todo.Repo.Migrations.AddUserIdToTodo do
  use Ecto.Migration

  def change do
    alter table(:todo) do
      add :user_id, references(:users)
    end
  end
end
