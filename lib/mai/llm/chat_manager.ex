defmodule Mai.Llm.ChatManager do
  use GenServer

  alias Task.Supervisor
  alias Mai.Llm.Chat

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def start_completion(owner, chat_id, prompt) do
    GenServer.cast(__MODULE__, {:start_completion, owner, chat_id, prompt})
  end

  def cancel(chat_id) do
    GenServer.cast(__MODULE__, {:cancel, chat_id})
  end

  def handle_cast({:start_completion, owner, chat_id, prompt}, state) do
    stream = Chat.initiate_stream(prompt)
    task = Supervisor.async(Mai.TaskSupervisor, fn -> Chat.process_stream(owner, stream) end)
    {:noreply, Map.put(state, chat_id, %{stream_pid: stream.task_pid, owner: owner, task: task})}
  end

  def handle_cast({:cancel, chat_id}, state) do
    case Map.get(state, chat_id) do
      nil ->
        {:noreply, state}

      %{stream_pid: stream_pid} ->
        OpenaiEx.HttpSse.cancel_request(stream_pid)
        {:noreply, Map.delete(state, chat_id)}
    end
  end
end
