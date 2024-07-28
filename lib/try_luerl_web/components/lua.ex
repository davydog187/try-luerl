defmodule TryLuerlWeb.Components.Lua do
  use TryLuerlWeb, :html

  attr :output, :list

  def console(assigns) do
    ~H"""
    <div class="border p-2">
      <p :for={output <- @output}><%= output %></p>
    </div>
    """
  end
end
