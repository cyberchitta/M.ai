defmodule Mai.Llm.Chat do
  alias OpenaiEx
  alias OpenaiEx.ChatMessage

  def send_completion_request(owner, prompt) do
    openai = System.fetch_env!("OPENAI_API_KEY") |> OpenaiEx.new()
    messages = create_messages(prompt)
    stream= openai |> stream(messages)
    stream.body_stream |> content_stream() |> send_chunks(owner)
  end

  defp create_messages(prompt) do
    [
      ChatMessage.system("You are an AI assistant."),
      ChatMessage.user(prompt)
    ]
  end

  defp create_request(args) do
    args
    |> Enum.into(%{model: "gpt-3.5-turbo", temperature: 0.7})
    |> OpenaiEx.Chat.Completions.new()
  end

  defp stream(openai, messages) do
    chat_request = create_request(messages: messages)
    openai |> OpenaiEx.Chat.Completions.create(chat_request, stream: true)
  end

  defp content_stream(body_stream) do
    body_stream
    |> Stream.flat_map(& &1)
    |> Stream.map(fn %{data: d} -> d |> Map.get("choices") |> Enum.at(0) |> Map.get("delta") end)
    |> Stream.filter(fn map -> map |> Map.has_key?("content") end)
    |> Stream.map(fn map -> map |> Map.get("content") end)
  end

  defp send_chunks(content_stream, owner) do
    content_stream |> Enum.each(fn chunk -> send(owner, {:chunk, chunk}) end)
    send(owner, :chunk_complete)
  end
end
