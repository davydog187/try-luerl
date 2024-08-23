defmodule TryLuerlWeb.Components.Lua do
  use TryLuerlWeb, :html

  attr :output, :list

  def console(assigns) do
    ~H"""
    <div class="bg-gray-900 text-gray-100 rounded-lg shadow-md p-4">
      <h3 class="text-lg font-semibold text-green-400">Console Output</h3>
      <pre :for={output <- @output} class="mt-2 whitespace-pre-wrap"><%= output %></pre>
    </div>
    """
  end
end
