defmodule IExHelpers do
  @doc """
  Copies the given term to the clipboard.

  If the term is binary, it is copied directly. Otherwise, the term is inspected
  with no limit and pretty formatting, and then copied.

  ## Examples

      iex> User |> Repo.get!(user_id) |> IExHelpers.copy
      :ok

  """
  def copy(term) do
    text =
      if is_binary(term) do
        term
      else
        inspect(term, limit: :infinity, pretty: true)
      end

    port = Port.open({:spawn, "pbcopy"}, [])
    true = Port.command(port, text)
    true = Port.close(port)

    :ok
  end
end

defmodule :_util do
  def cls(), do: clear()
  def ra(), do: recompile()
  defmacro tc(expression) do
    quote do
      {t, res} = :timer.tc(fn -> unquote(expression) end)
      {res, t / 1000_000}
    end
  end
end

import :_util
