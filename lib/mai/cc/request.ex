defmodule Mai.CC.Message do
  @moduledoc false
  def system(content) do
    create("system", content)
  end

  def user(content) do
    create("user", content)
  end

  def assistant(content) do
    create("assistant", content)
  end

  def create(role, content) do
    %{
      role: role,
      content: content
    }
  end
end
