defmodule TryLuerl.Examples do
  import Lua, only: [sigil_LUA: 2]

  def fibonacci do
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

  def hello do
    ~LUA"""
    print("Hello Robert!")
    """
  end

  def weather do
    ~LUA"""
    print(weather.today())
    """
  end
end
