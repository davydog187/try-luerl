defmodule TryLuerl.API.Global do
  use Lua.API

  deflua print(args) do
    send(self(), {:print, args})
    []
  end
end
