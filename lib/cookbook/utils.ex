defmodule Cookbook.Utils do
  def trim(nil), do: nil

  def trim(value) when is_binary(value), do: String.trim(value)

  def downcase(nil), do: nil

  def downcase(value) when is_binary(value), do: String.downcase(value)
end
