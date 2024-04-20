defmodule MaiWeb.ChatsLive do
  use MaiWeb, :live_view

  import MaiWeb.Live.ChatsLive.Html

  alias Mai.Contexts.Message
  alias MaiWeb.UiState

  @user_id "a4b22541-b2a5-46bf-b451-09c6d0c1d6f0"

  def mount(%{"id" => chat_id}, _session, socket) do
    {:ok, assign(socket, UiState.index(@user_id, chat_id))}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, UiState.index(@user_id))}
  end

  def handle_event("submit", %{"prompt-textarea" => prompt}, socket) do
    main = socket.assigns.main

    chat_id = main.chat.id
    turn_number = length(main.messages) + 1

    streaming = %{
      user: Message.user(chat_id, turn_number, prompt) |> Map.put(:id, nil),
      assistant: Message.assistant(chat_id, turn_number + 1, "") |> Map.put(:id, nil)
    }

    send(self(), {:start_completion, streaming})
    {:noreply, assign(socket, main: %{main | uistate: %{prompt: "", streaming: streaming}})}
  end

  def handle_info({:start_completion, streaming}, socket) do
    task = Task.async(Mai.Llm.Chat, :send_completion_request, [self(), streaming.user.content])
    main = socket.assigns.main

    {:noreply,
     assign(socket, main: %{main | uistate: %{main.uistate | streaming: streaming}}, task: task)}
  end

  def handle_info({:chunk, chunk}, socket) do
    main = socket.assigns.main
    streaming = main.uistate.streaming
    assistant = streaming.assistant
    content = assistant.content

    {:noreply,
     assign(socket,
       main: %{
         main
         | uistate: %{
             main.uistate
             | streaming: %{streaming | assistant: %{assistant | content: content <> " " <> chunk}}
           }
       }
     )}
  end

  def handle_info({_ref, :chunk_complete}, socket) do
    IO.puts("Response Complete 1")
    {:noreply, socket}
  end

  def handle_info(:chunk_complete, socket) do
    IO.puts("Response Complete")
    main = socket.assigns.main
    {:noreply, assign(socket, main: %{main | uistate: %{main.uistate | streaming: nil}})}
  end

  def handle_info({:cancel_response}, socket) do
    # Cancel the ongoing response stream
    # Clear any partial response from the UI

    main = socket.assigns.main
    {:noreply, assign(socket, main: %{main | uistate: %{main.uistate | streaming: nil}})}
  end

  def handle_info(message, socket) do
    IO.inspect(message, label: "Unmatched message")
    {:noreply, socket}
  end
end
