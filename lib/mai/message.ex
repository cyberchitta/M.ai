defmodule Mai.Message do
  def mai(msg) do
    create(:mai, msg)
  end

  def create(
        model,
        msg,
        timestamp \\ DateTime.utc_now(),
        files \\ [],
        done \\ true,
        error \\ "",
        info \\ %{},
        rating \\ 1,
        parent_id \\ nil
      ) do
    %{
      id: nil,
      role: msg.role,
      content: msg.content,
      model: model,
      timestamp: timestamp,
      files: files,
      done: done,
      error: error,
      info: info,
      rating: rating,
      parent_id: parent_id
    }
  end
end
