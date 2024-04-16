defmodule MaiWeb.Live.ChatsLive.Html do
  use MaiWeb, :html

  embed_templates "common/*.html"
  embed_templates "*.html"
  embed_templates "sidebar/*.html"
  embed_templates "chat/*.html"
end
