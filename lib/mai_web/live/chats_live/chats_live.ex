defmodule MaiWeb.ChatsLive do
  use MaiWeb, :live_view

  import MaiWeb.Live.ChatsLive.Html

  alias Mai.Schemas.Message
  alias Mai.RepoPostgres

  alias MaiWeb.UiState.Index

  @user_id "a4b22541-b2a5-46bf-b451-09c6d0c1d6f0"

  def mount(%{"id" => chat_id}, _session, socket) do
    {:ok, assign(socket, Index.get(@user_id, chat_id))}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, Index.get(@user_id))}
  end

  def handle_event(
        "submit",
        %{"_target" => ["prompt-textarea"], "prompt-textarea" => input_value},
        socket
      ) do
    chat_id = socket.assigns.main.chat.id
    turn_number = length(socket.assigns.main.chat.messages) + 1

    message_params = %{
      content: input_value,
      role: "user",
      chat_id: chat_id,
      turn_number: turn_number
    }

    {:ok, message} = RepoPostgres.insert(Message.changeset(%Message{}, message_params))

    {:noreply, assign(socket, streaming: true, input_value: "")}

    Phoenix.PubSub.subscribe(YourApp.PubSub, "chat:#{chat_id}")
    send(self(), {:stream_response, message})

    {:noreply, socket}
  end

  def handle_info({:stream_response, _message}, socket) do
    # Call the chat API to stream the response
    # Update the message list in the UI as the response is received
    # Once the response is complete, save the assistant's message to the database

    {:noreply, socket}
  end

  def handle_info(%{event: "cancel_response"}, socket) do
    # Cancel the ongoing response stream
    # Clear any partial response from the UI

    {:noreply, assign(socket, streaming: false)}
  end
end
