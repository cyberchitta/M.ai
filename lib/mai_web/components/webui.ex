defmodule MaiWeb.Components.Webui do
  use MaiWeb, :html

  embed_templates "webui/common/*.html"

  attr :content, :string, required: true
  attr :placement, :string, default: "top"
  attr :touch, :string, default: "true"
  def tooltip(assigns)

  embed_templates "webui/*.html"

  def navbar(assigns)

  def model_selector(assigns)
  def chat(assigns)
  def messages(assigns)
  def message_input(assigns)

  embed_templates "webui/messages/*.html"

  def response(assigns)

  embed_templates "webui/inputs/*.html"

  attr :files, :list, required: true
  def previews(assigns)

  attr :submit_prompt, :any, required: true
  attr :suggestion_prompts, :list, default: []

  def suggestions(assigns) do
    prompts =
      if length(assigns.suggestion_prompts) <= 4 do
        assigns.suggestion_prompts
      else
        assigns.suggestion_prompts
        |> Enum.shuffle()
        |> Enum.take(4)
      end

    prompts_with_class =
      Enum.map(prompts, fn {prompt, index} ->
        class =
          case index do
            index when index > 1 -> "basis-full sm:basis-1/2 p-[5px] px-1 hidden sm:inline-flex"
            _ -> "basis-full sm:basis-1/2 p-[5px] px-1"
          end

        Map.put(prompt, :_class, class)
      end)

    assigns
    |> assign(:prompts, prompts_with_class)
    |> inner_suggestions()
  end

  def inner_suggestions(assigns)

  attr :messages, :list, required: true
  attr :speech_recognition_enabled, :boolean, required: true
  attr :is_recording, :boolean, required: true
  attr :prompt, :string, required: true

  def voice_n_send(assigns)
end
