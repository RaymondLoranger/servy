defmodule Servy.MixProject do
  use Mix.Project

  def project do
    [
      app: :servy,
      description: "A humble HTTP server",
      version: "0.1.5",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eex, :observer, :wx, :runtime_tools],
      mod: {Servy.TopSupervisor, :ok},
      env: [port: 3000]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:earmark, "~> 1.4"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:io_ansi_plus, "~> 0.1"},
      {:persist_config, "~> 0.1"},
      {:poison, "~> 5.0"}
    ]
  end
end
