defmodule MaiWeb.UiState do
  alias Mai.Contexts.Chat
  alias Mai.Contexts.User

  def index(user_id) do
    suggestions = Mai.Contexts.Suggestion.get_default()
    picked = Enum.random(suggestions)
    prompt = picked.title <> " " <> picked.description
    %{sidebar: sidebar(user_id), main: %{suggestions: suggestions, uistate: uistate(prompt)}}
  end

  def index(user_id, chat_id) do
    chat = Mai.Contexts.Chat.get_chat_details(chat_id)
    %{sidebar: sidebar(user_id), main: Map.put(chat, :uistate, uistate(""))}
  end

  defp sidebar(user_id) do
    %{periods: Chat.list_by_period(user_id), user: User.get_by_id(user_id)}
  end

  defp uistate(prompt) do
    %{streaming: nil, prompt: prompt}
  end
end
