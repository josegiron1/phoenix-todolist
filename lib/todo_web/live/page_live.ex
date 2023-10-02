defmodule TodoWeb.LiveView do
  use Phoenix.LiveView
  use TodoWeb, :html

  alias Todo

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    data = Todo.Todo.get_todos_by_user_id(user_id)
    changeset = Todo.Todo.Todo.changeset(%Todo.Todo.Todo{}, %{})
    form = to_form(changeset)
    {:ok, assign(socket, data: data, form: form)}
  end

  def handle_event("save", params, socket) do
    user_id = socket.assigns.current_user.id
    params_with_user_id = Map.put(params["todo"], "user_id", user_id)
    todo = %Todo.Todo.Todo{}
    changeset = Todo.Todo.Todo.changeset(todo, params_with_user_id)

    case Todo.Repo.insert(changeset) do
      {:ok, todo} ->
        todos = [todo | socket.assigns.data]
        {:noreply, assign(socket, :data, todos)}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("toggle_task", params, socket) do
    todo = Todo.Repo.get_by(Todo.Todo.Todo, id: params["id"])

    changeset = Todo.Todo.Todo.changeset(todo, %{"completed" => params["value"]})

    Todo.Repo.update(changeset)
    |> assign_todos(socket)
    |> handle_event_response(socket)
  end

  def handle_event_response({:ok, todos}, socket)
    {:noreply, assign(socket, data: todos)}
  end

  handle_event_response({:error, changeset}, socket)
    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def assign_todos({:ok, todos}, socket)
    Enum.map(socket.assigns.data, fn t ->
      if t.id == todo.id do
        todo
      else
        t
      end
    end)
  end

  def assign_todos({:error, err}, socket)
    err
  end

  def render(assigns) do
    ~H"""
    <section class="h-screen w-screen flex flex-col mt-3 items-center gap-6">
      <.simple_form
        for={@form}
        class="border p-4 px-12 rounded-md w-1/2"
        phx-submit="save"
        phx-prevent-default
      >
        <.input field={@form[:task]} label="Task" type="text" />
        <.button type="submit">Add Task</.button>
      </.simple_form>
      <div class="flex gap-3">
        <ul>
          <%= if length(@data) == 0 do %>
            <li>No tasks yet</li>
          <% end %>
          <%= for data <- @data do %>
            <%= if data.completed == false do %>
              <div class="flex gap-3 justify-between">
                <li><%= data.task %></li>
                <.input
                  name="completed"
                  field={@form[:completed]}
                  label="Completed"
                  type="checkbox"
                  phx-click="toggle_task"
                  phx-value-id={data.id}
                />
              </div>
            <% end %>
          <% end %>
        </ul>
      </div>
    </section>
    """
  end
end
