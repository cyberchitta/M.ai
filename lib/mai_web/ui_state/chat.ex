defmodule MaiWeb.UiState.Chat do
  import MaiWeb.UiState.Message

  def create_summary(id, title) do
    %{id: id, title: title}
  end

  def get_chat(_chat_id) do
    %{
      messages: [
        create(%{role: "user", content: "Hello LLM", turn_number: 0, id: "new message id"})
      ]
    }
  end
end
