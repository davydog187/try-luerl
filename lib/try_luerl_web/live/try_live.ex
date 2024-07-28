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
    {:ok, socket |> assign(:output, []) |> assign_form(changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"try_live" => _params}, socket) do
    {:noreply, socket}
  end

  def handle_event("execute", %{"try_live" => %{"code" => code}}, socket) do
    {output, _} = Lua.eval!(setup_lua(), code)

    {:noreply, put_flash(socket, :info, "Executed Lua with output #{inspect(output)}")}
  rescue
    error ->
      {:noreply, put_flash(socket, :error, "Failed to execute Lua #{inspect(error)}")}
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
    print("hello Robert!")

    return 22 * 11
    """
  end

  defp setup_lua do
    Lua.new()
    |> Lua.load_api(TryLuerl.API.Global)
  end
end
