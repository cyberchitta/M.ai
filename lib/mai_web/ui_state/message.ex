defmodule MaiWeb.UiState.Message do
  def create(msg_attrs) do
    %{
      id: msg_attrs.id,
      role: msg_attrs.role,
      content: msg_attrs.content,
      turn_number: msg_attrs.turn_number
    }
  end
end
