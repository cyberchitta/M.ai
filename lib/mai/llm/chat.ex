defmodule Mai.Llm.Chat do
  @example ~S"""
    You're correct. In Elixir, there is no shorthand syntax equivalent to `Map.put/3` for adding a new key-value pair to a map.

    The `|` operator is specifically used for updating existing keys in a map, and it raises a `KeyError` if the key doesn't exist.

    When you need to add a new key-value pair to a map, you have to use the `Map.put/3` or `Map.put_new/3` function explicitly. These functions provide a clear and explicit way to add new key-value pairs to a map.

    While there isn't a direct shorthand syntax for `Map.put/3`, you can still use the pipe operator `|>` to chain multiple `Map.put/3` calls together for readability:

    ```elixir
    map
    |> Map.put(:key1, value1)
    |> Map.put(:key2, value2)
    |> Map.put(:key3, value3)
    ```

    This code creates a new map with the added key-value pairs, starting from the original `map`.

    In summary, while there is a shorthand syntax for updating existing keys in a map using the `|` operator, there is no direct shorthand equivalent for adding new key-value pairs using `Map.put/3`. You need to use the `Map.put/3` or `Map.put_new/3` function explicitly when adding new key-value pairs to a map.
  """

  def send_completion_request(owner, _prompt) do
    chunks = String.split(@example, " ")

    Enum.each(chunks, fn chunk ->
      send(owner, {:chunk, chunk})
      Process.sleep(200)
    end)

    send(owner, :chunk_complete)
  end
end
