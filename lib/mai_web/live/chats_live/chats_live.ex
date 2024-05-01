defmodule MaiWeb.ChatsLive do
  use MaiWeb, :live_view

  import MaiWeb.Live.ChatsLive.Html

  alias Mai.Contexts.Message
  alias MaiWeb.UiState

  def mount(%{"id" => chat_id}, %{"user_id" => user_id}, socket) do
    {:ok, socket |> assign(UiState.index(user_id, chat_id)) |> enable_gauth()}
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    {:ok, socket |> assign(UiState.index(user_id)) |> enable_gauth()}
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(UiState.index(nil)) |> enable_gauth()}
  end

  defp enable_gauth(socket) do
    oauth_google_url = MaiWeb.Endpoint.url() |> ElixirAuthGoogle.generate_oauth_url()
    socket |> assign(oauth_google_url: oauth_google_url)
  end

  def handle_event("submit", %{"prompt-textarea" => prompt}, socket) do
    main = socket.assigns.main

    chat_id = main.chat.id
    turn_number = length(main.messages) + 1

    streaming = %{
      user: Message.user(chat_id, turn_number, prompt) |> Map.put(:id, nil),
      assistant: Message.assistant(chat_id, turn_number + 1, "") |> Map.put(:id, nil),
      task: nil
    }

    send(self(), {:start_completion, streaming})
    {:noreply, assign(socket, main: main |> UiState.with_streaming(streaming))}
  end

  def handle_event("cancel", _, socket) do
    main = socket.assigns.main
    streaming = main.uistate.streaming

    if streaming do
      Process.exit(streaming.task.pid, :normal)
      {:noreply, assign(socket, main: main |> UiState.with_streaming())}
    else
      {:noreply, socket}
    end
  end

  def handle_info({:start_completion, streaming}, socket) do
    task = Task.async(Mai.Llm.Chat, :send_completion_request, [self(), streaming.user.content])
    main = socket.assigns.main |> UiState.with_streaming(streaming |> UiState.with_task(task))
    {:noreply, assign(socket, main: main)}
  end

  def handle_info({:chunk, chunk}, socket) do
    main = socket.assigns.main
    streaming = main.uistate.streaming |> UiState.with_chunk(chunk)
    {:noreply, assign(socket, main: main |> UiState.with_streaming(streaming))}
  end

  def handle_info(:chunk_complete, socket) do
    main = socket.assigns.main
    Task.shutdown(main.uistate.streaming.task)
    {:noreply, assign(socket, main: main |> UiState.with_streaming())}
  end

  def handle_info(message, socket) do
    IO.inspect(message, label: "Unmatched message")
    {:noreply, socket}
  end
end
