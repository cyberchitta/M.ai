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
    chat = Chat.details(chat_id)
    %{sidebar: sidebar(user_id), main: Map.put(chat, :uistate, uistate(""))}
  end

  defp sidebar(user_id) do
    unless is_nil(user_id) do
      %{periods: Chat.list_by_period(user_id), user: User.get_by_id(user_id)}
    else
      %{periods: [], user: nil}
    end
  end

  defp uistate(prompt) do
    %{streaming: nil, prompt: prompt}
  end

  def with_streaming(main, streaming \\ nil) do
    %{main | uistate: %{main.uistate | streaming: streaming}}
  end

  def with_cancel_pid(main, pid \\ nil) do
    %{main | uistate: %{main.uistate | streaming: %{main.uistate.streaming | cancel_pid: pid}}}
  end

  def with_chunk(streaming, chunk) do
    assistant = streaming.assistant
    content = assistant.content
    %{streaming | assistant: %{assistant | content: content <> " " <> chunk}}
  end
end
