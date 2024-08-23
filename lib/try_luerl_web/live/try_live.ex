defmodule TryLuerlWeb.TryLive do
  use TryLuerlWeb, :live_view
  use Ecto.Schema

  alias TryLuerlWeb.Components.Lua, as: LuaComponents

  import Lua

  embedded_schema do
    field :code, :string
  end

  @impl Phoenix.LiveView
  def mount(_, _, socket) do
    changeset = changeset(%__MODULE__{}, %{code: default_code()})
    {:ok, socket |> assign(output: [], code: default_code()) |> assign_form(changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event("execute", _, socket) do
    {output, _} = Lua.eval!(setup_lua(), socket.assigns.code)

    {:noreply, put_flash(socket, :info, "Executed Lua with output #{inspect(output)}")}
  rescue
    error ->
      {:noreply, put_flash(socket, :error, "Failed to execute Lua #{inspect(error)}")}
  end

  def handle_event("code_updated", %{"code" => code}, socket) do
    {:noreply, assign(socket, :code, code)}
  end

  @impl Phoenix.LiveView
  def handle_info({:print, args}, socket) do
    {:noreply, update(socket, :output, &[inspect(args) | &1])}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp changeset(data, params) do
    import Ecto.Changeset

    data
    |> cast(params, [:code])
    |> validate_required([:code])
  end

  defp default_code do
    ~LUA"""
    -- Function to generate the Fibonacci sequence
    function generate_fibonacci(n)
        local sequence = {}
        local a, b = 0, 1

        for i = 1, n do
            table.insert(sequence, a)
            a, b = b, a + b
        end

        return sequence
    end

    -- Example usage
    local fib_sequence = generate_fibonacci(10)

    for _, value in ipairs(fib_sequence) do
        print(value)
    end
    """
  end

  defp setup_lua do
    Lua.new()
    |> Lua.load_api(TryLuerl.API.Global)
  end
end
