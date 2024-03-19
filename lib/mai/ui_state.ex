defmodule Mai.UiState do
  def create_assigns() do
    loaded = true
    title = "Welcome to Mai"
    init_new_chat = false
    auto_scroll = true
    chat_id = nil
    processing = false
    send_prompt = false
    stop_response = false
    select_detail = false
    messages_assigns = Mai.UiState.Messages.create_assigns([])
    selected_models = %{}
    selected_modelfiles_assigns = %{}
    history_assigns = %{}
    files_assigns = Mai.UiState.Files.create_assigns([])
    continue_generation = false
    regenerate_response = false
    config_assigns = Mai.UiState.Config.create_assigns([], [])
    prompt = ""
    submit_prompt = false
    webui_name = nil
    webui_base_url = nil
    settings_assigns = Mai.UiState.Settings.create_assigns(false)
    user = nil
    confirm_edit_message = false
    confirm_edit_response_message = false
    show_previous_message = false
    show_next_message = false
    copy_to_clipboard = false
    bottom_padding = false
    suggestion_prompts_assigns = %{}
    chat_input_placeholder = nil
    file_upload_enabled = false
    speech_recognition_enabled = false
    is_recording = false
    loading_speech = false
    speaking = false
    generating_image = false

    Mai.UiState.Chat.create_assigns(
      loaded,
      title,
      init_new_chat,
      auto_scroll,
      chat_id,
      processing,
      send_prompt,
      stop_response,
      select_detail,
      messages_assigns,
      selected_models,
      selected_modelfiles_assigns,
      history_assigns,
      files_assigns,
      continue_generation,
      regenerate_response,
      config_assigns,
      prompt,
      submit_prompt,
      webui_name,
      webui_base_url,
      settings_assigns,
      user,
      confirm_edit_message,
      confirm_edit_response_message,
      show_previous_message,
      show_next_message,
      copy_to_clipboard,
      bottom_padding,
      suggestion_prompts_assigns,
      chat_input_placeholder,
      file_upload_enabled,
      speech_recognition_enabled,
      is_recording,
      loading_speech,
      speaking,
      generating_image
    )
  end
end

defmodule Mai.UiState.Chat do
  def create_assigns(
        loaded,
        title,
        init_new_chat,
        auto_scroll,
        chat_id,
        processing,
        send_prompt,
        stop_response,
        select_detail,
        messages_assigns,
        selected_models,
        selected_modelfiles_assigns,
        history_assigns,
        files_assigns,
        continue_generation,
        regenerate_response,
        config_assigns,
        prompt,
        submit_prompt,
        webui_name,
        webui_base_url,
        settings_assigns,
        user,
        confirm_edit_message,
        confirm_edit_response_message,
        show_previous_message,
        show_next_message,
        copy_to_clipboard,
        bottom_padding,
        suggestion_prompts_assigns,
        chat_input_placeholder,
        file_upload_enabled,
        speech_recognition_enabled,
        is_recording,
        loading_speech,
        speaking,
        generating_image
      ) do
    %{
      loaded: loaded,
      title: title,
      init_new_chat: init_new_chat,
      auto_scroll: auto_scroll,
      chat_id: chat_id,
      processing: processing,
      send_prompt: send_prompt,
      stop_response: stop_response,
      select_detail: select_detail,
      messages: messages_assigns,
      selected_models: selected_models,
      selected_modelfiles: selected_modelfiles_assigns,
      history: history_assigns,
      files: files_assigns,
      continue_generation: continue_generation,
      regenerate_response: regenerate_response,
      config: config_assigns,
      prompt: prompt,
      submit_prompt: submit_prompt,
      webui_name: webui_name,
      webui_base_url: webui_base_url,
      settings: settings_assigns,
      user: user,
      confirm_edit_message: confirm_edit_message,
      confirm_edit_response_message: confirm_edit_response_message,
      show_previous_message: show_previous_message,
      show_next_message: show_next_message,
      copy_to_clipboard: copy_to_clipboard,
      bottom_padding: bottom_padding,
      suggestion_prompts: suggestion_prompts_assigns,
      chat_input_placeholder: chat_input_placeholder,
      file_upload_enabled: file_upload_enabled,
      speech_recognition_enabled: speech_recognition_enabled,
      is_recording: is_recording,
      loading_speech: loading_speech,
      speaking: speaking,
      generating_image: generating_image
    }
  end
end

defmodule Mai.UiState.Navbar do
  def create_assigns(settings_assigns, init_new_chat, title, webui_name, share_enabled) do
    %{
      settings: settings_assigns,
      init_new_chat: init_new_chat,
      title: title,
      webui_name: webui_name,
      share_enabled: share_enabled
    }
  end
end

defmodule Mai.UiState.ModelSelector do
  def create_assigns(selected_models, disabled, models_assigns) do
    %{
      selected_models: selected_models,
      disabled: disabled,
      models: models_assigns
    }
  end
end

defmodule Mai.UiState.Models do
  def create_assigns(models) do
    Enum.map(models || [], fn model ->
      %{
        id: model[:id],
        name: model[:name],
        size: model[:size]
      }
    end)
  end
end

defmodule Mai.UiState.Messages do
  def create_assigns(messages) do
    Enum.map(messages || [], fn message ->
      %{
        id: message[:id],
        role: message[:role],
        content: message[:content],
        parent_id: message[:parent_id],
        children_ids: message[:children_ids],
        model: message[:model],
        timestamp: message[:timestamp],
        files: Mai.UiState.Files.create_assigns(message[:files]),
        error: message[:error],
        done: message[:done],
        rating: message[:rating],
        info: message[:info]
      }
    end)
  end
end

defmodule Mai.UiState.Settings do
  def create_assigns(full_screen_mode) do
    %{
      full_screen_mode: full_screen_mode
    }
  end
end

defmodule Mai.UiState.History do
  def create_assigns(history_messages_assigns) do
    %{
      messages: history_messages_assigns
    }
  end
end

defmodule Mai.UiState.HistoryMessages do
  def create_assigns(messages) do
    Map.new(messages, fn {id, message} ->
      {
        id,
        %{
          children_ids: message[:children_ids]
        }
      }
    end)
  end
end

defmodule Mai.UiState.Files do
  def create_assigns(files) do
    Enum.map(files || [], fn file ->
      %{
        type: file[:type],
        url: file[:url],
        name: file[:name],
        upload_status: file[:upload_status],
        title: file[:title]
      }
    end)
  end
end

defmodule Mai.UiState.SelectedModelfiles do
  def create_assigns(selected_modelfiles) do
    Map.new(selected_modelfiles || %{}, fn {id, modelfile} ->
      {
        id,
        %{
          image_url: modelfile[:image_url],
          title: modelfile[:title]
        }
      }
    end)
  end
end

defmodule Mai.UiState.Config do
  def create_assigns(default_prompt_suggestions, images) do
    %{
      default_prompt_suggestions: default_prompt_suggestions,
      images: images
    }
  end
end

defmodule Mai.UiState.SuggestionPrompts do
  def create_assigns(suggestion_prompts) do
    Enum.map(suggestion_prompts || [], fn prompt ->
      %{
        _class: prompt[:_class],
        content: prompt[:content],
        title: prompt[:title]
      }
    end)
  end
end

defmodule Mai.UiState.Welcome do
  def create_assigns(models, selected_modelfiles_assigns) do
    %{
      models: models,
      modelfiles: selected_modelfiles_assigns
    }
  end
end

defmodule Mai.UiState.Request do
  def create_assigns(
        id,
        user,
        message_assigns,
        is_first_message,
        siblings,
        confirm_edit_message,
        show_previous_message,
        show_next_message,
        copy_to_clipboard,
        edit,
        src,
        selected_modelfiles_assigns,
        editedContent
      ) do
    %{
      id: id,
      user: user,
      message: message_assigns,
      is_first_message: is_first_message,
      siblings: siblings,
      confirm_edit_message: confirm_edit_message,
      show_previous_message: show_previous_message,
      show_next_message: show_next_message,
      copy_to_clipboard: copy_to_clipboard,
      edit: edit,
      src: src,
      modelfiles: selected_modelfiles_assigns,
      editedContent: editedContent
    }
  end
end

defmodule Mai.UiState.Message do
  def create_assigns(id, role, content, parent_id, model, timestamp, files_assigns, error, done) do
    %{
      id: id,
      role: role,
      content: content,
      parent_id: parent_id,
      model: model,
      timestamp: timestamp,
      files: files_assigns,
      error: error,
      done: done
    }
  end
end

defmodule Mai.UiState.Attachments do
  def create_assigns(message_assigns, selected_modelfiles_assigns) do
    %{
      message: message_assigns,
      modelfiles: selected_modelfiles_assigns
    }
  end
end

defmodule Mai.UiState.InEdit do
  def create_assigns(message_id, editedContent) do
    %{
      message: %{id: message_id},
      editedContent: editedContent
    }
  end
end

defmodule Mai.UiState.ReqWithControls do
  def create_assigns(message_id, message_content, siblings, is_first_message) do
    %{
      message: %{
        id: message_id,
        content: message_content
      },
      siblings: siblings,
      is_first_message: is_first_message
    }
  end
end

defmodule Mai.UiState.Response do
  def create_assigns(
        id,
        message_assigns,
        selected_modelfiles_assigns,
        webui_base_url,
        siblings,
        is_last_message,
        confirm_edit_response_message,
        show_previous_message,
        show_next_message,
        rate_message,
        copy_to_clipboard,
        continue_generation,
        regenerate_response,
        edit,
        edited_content,
        tokens_assigns,
        config_assigns,
        loading_speech,
        speaking,
        generating_image
      ) do
    %{
      id: id,
      message: message_assigns,
      modelfiles: selected_modelfiles_assigns,
      webui_base_url: webui_base_url,
      siblings: siblings,
      is_last_message: is_last_message,
      confirm_edit_response_message: confirm_edit_response_message,
      show_previous_message: show_previous_message,
      show_next_message: show_next_message,
      rate_message: rate_message,
      copy_to_clipboard: copy_to_clipboard,
      continue_generation: continue_generation,
      regenerate_response: regenerate_response,
      edit: edit,
      edited_content: edited_content,
      tokens: tokens_assigns,
      config: config_assigns,
      loading_speech: loading_speech,
      speaking: speaking,
      generating_image: generating_image
    }
  end
end

defmodule Mai.UiState.Tokens do
  def create_assigns(tokens) do
    Enum.map(tokens || [], fn token ->
      %{
        type: token[:type],
        lang: token[:lang],
        text: token[:text],
        raw: token[:raw]
      }
    end)
  end
end

defmodule Mai.UiState.ProfileImage do
  def create_assigns(src) do
    %{
      src: src
    }
  end
end

defmodule Mai.UiState.Name do
  def create_assigns(name) do
    %{
      name: name
    }
  end
end

defmodule Mai.UiState.Image do
  def create_assigns(src) do
    %{
      src: src
    }
  end
end

defmodule Mai.UiState.CodeBlock do
  def create_assigns(lang, code) do
    %{
      lang: lang,
      code: code
    }
  end
end

defmodule Mai.UiState.ResControls do
  def create_assigns(
        message_id,
        message_rating,
        message_info,
        siblings,
        is_last_message,
        continue_generation,
        regenerate_response,
        loading_speech,
        speaking,
        generating_image,
        config_assigns
      ) do
    %{
      message: %{
        id: message_id,
        rating: message_rating,
        info: message_info
      },
      siblings: siblings,
      is_last_message: is_last_message,
      continue_generation: continue_generation,
      regenerate_response: regenerate_response,
      loading_speech: loading_speech,
      speaking: speaking,
      generating_image: generating_image,
      config: config_assigns
    }
  end
end

defmodule Mai.UiState.MessageInput do
  def create_assigns(
        auto_scroll,
        messages_assigns,
        prompt,
        suggestion_prompts_assigns,
        submit_prompt,
        user,
        chat_input_placeholder,
        file_upload_enabled,
        files_assigns,
        speech_recognition_enabled,
        is_recording,
        select_detail
      ) do
    %{
      auto_scroll: auto_scroll,
      messages: messages_assigns,
      prompt: prompt,
      suggestion_prompts: suggestion_prompts_assigns,
      submit_prompt: submit_prompt,
      user: user,
      chat_input_placeholder: chat_input_placeholder,
      file_upload_enabled: file_upload_enabled,
      files: files_assigns,
      speech_recognition_enabled: speech_recognition_enabled,
      is_recording: is_recording,
      select_detail: select_detail
    }
  end
end

defmodule Mai.UiState.PromptCommands do
  def create_assigns(prompt) do
    %{
      prompt: prompt
    }
  end
end

defmodule Mai.UiState.Documents do
  def create_assigns(prompt, select_detail) do
    %{
      prompt: prompt,
      select_detail: select_detail
    }
  end
end

defmodule Mai.UiState.Suggestions do
  def create_assigns(suggestion_prompts_assigns, submit_prompt) do
    %{
      prompts: suggestion_prompts_assigns,
      submit_prompt: submit_prompt
    }
  end
end

defmodule Mai.UiState.Previews do
  def create_assigns(files_assigns) do
    %{
      files: files_assigns
    }
  end
end

defmodule Mai.UiState.VoiceNSend do
  def create_assigns(
        voice_n_send_messages_assigns,
        speech_recognition_enabled,
        is_recording,
        prompt
      ) do
    %{
      messages: voice_n_send_messages_assigns,
      speech_recognition_enabled: speech_recognition_enabled,
      is_recording: is_recording,
      prompt: prompt
    }
  end
end

defmodule Mai.UiState.VoiceNSendMessages do
  def create_assigns(messages) do
    Enum.map(messages || [], fn message ->
      %{
        done: message[:done]
      }
    end)
  end
end
