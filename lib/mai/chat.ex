defmodule Mai.Chat do
  @moduledoc false
  @enforce_keys [:id]
  defstruct id: nil, title: "", messages: []

  def new_chat(attrs \\ %{}) do
    %Mai.Chat{
      id: Map.get(attrs, "id", nil),
      title: Map.get(attrs, "title", ""),
      messages: Map.get(attrs, "messages", [])
    }
  end

  def add_message(chat, message) do
    update(chat, :messages, fn messages -> [message | messages] end)
  end

  defp update(%Mai.Chat{} = chat, field, fun) when is_function(fun, 1) do
    Map.update!(chat, field, fun)
  end
end
