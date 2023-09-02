defmodule Todo.Todo do
  import Ecto.Query, warn: false
  alias Todo.Repo

  alias Todo.Todo.{Todo}

  def get_todos_by_user_id(user_id) do
     Repo.all(from t in Todo, where: t.user_id == ^user_id)
  end

end
