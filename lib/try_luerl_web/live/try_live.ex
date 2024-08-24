defmodule TryLuerlWeb.TryLive do
  use TryLuerlWeb, :live_view

  alias TryLuerl.Examples

  alias TryLuerlWeb.Components.Lua, as: LuaComponents

  @impl Phoenix.LiveView
  def mount(_, _, socket) do
    examples = examples()
    {name, code} = Enum.random(examples)

    {:ok,
     socket
     |> assign(output: [], code: code.(), name: name, examples: Map.keys(examples))}
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

  def handle_event("change-example", %{"name" => name}, socket) do
    code = Map.get_lazy(examples(), name, &Examples.fibonacci/0)

    {:noreply,
     socket |> assign(code: code, name: name) |> push_event(:set_code, %{code: code.()})}
  end

  @impl Phoenix.LiveView
  def handle_info({:print, args}, socket) do
    {:noreply, update(socket, :output, &[inspect(args) | &1])}
  end

  defp setup_lua do
    Lua.new()
    |> Lua.load_api(TryLuerl.API.Global)
  end

  defp examples do
    %{
      "fibonacci" => &Examples.fibonacci/0,
      "hello" => &Examples.hello/0,
      "weather" => &Examples.weather/0
    }
  end
end
