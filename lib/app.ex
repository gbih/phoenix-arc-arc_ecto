defmodule App do
  @moduledoc """
  App keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  
end


defimpl Phoenix.HTML.Safe, for: Map do
  def to_iodata(data), do: data |> Poison.encode! |> Plug.HTML.html_escape
end