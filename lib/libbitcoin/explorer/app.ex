defmodule Libbitcoin.Explorer.App do
  use Application

  def start(_start_type, _start_args) do
    Libbitcoin.Explorer.Sup.start_link
  end

  def stop(_reason) do
    :ok
  end
end
