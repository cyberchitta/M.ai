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

    IO.inspect(streaming, label: "Start Streaming")
    {:noreply, assign(socket, main: %{main | uistate: %{prompt: "", streaming: streaming}})}
    send(self(), {:stream_response, streaming})
    {:noreply, socket}
  end

  def handle_info({:stream_response, streaming}, socket) do
    # Call the chat API to stream the response
    # Update the streaming.assistant_message with the partial response
    IO.inspect(streaming, label: "Streaming")

    main = socket.assigns.main
    {:noreply, assign(socket, main: %{main | uistate: %{main.uistate | streaming: streaming}})}
  end

  def handle_info(%{event: "response_complete", streaming: streaming}, socket) do
    streaming.user |> Message.insert!()
    streaming.assistant |> Message.insert!()

    IO.inspect(streaming, label: "Complete Streaming")

    _main = socket.assigns.main
    ##    {:noreply, assign(socket, main: %{main | uistate: %{main.uistate | streaming: nil}})}
    {:noreply, socket}
  end

  def handle_info(%{event: "cancel_response"}, socket) do
    # Cancel the ongoing response stream
    # Clear any partial response from the UI

    main = socket.assigns.main
    {:noreply, assign(socket, main: %{main | uistate: %{main.uistate | streaming: nil}})}
  end
end
