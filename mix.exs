defmodule Libbitcoin.Explorer.Mixfile do
  use Mix.Project

  def project do
    [app: :libbitcoin_explorer,
     version: "0.0.1",
     elixir: "~> 1.1-dev",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :exjsx],
     mod: {Libbitcoin.Explorer.App, []}]
  end

  defp deps do
    [
      {:exjsx, "~> 3.2.0"}
    ]
  end
end
