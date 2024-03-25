defmodule MaiWeb.Components.Webui do
  use MaiWeb, :html

  embed_templates "webui/common/*.html"

  embed_templates "webui/*.html"

  embed_templates "webui/sidebar/*.html"

  embed_templates "webui/chat/*.html"
end
