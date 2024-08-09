defmodule Proxy.MixProject do
  use Mix.Project

  @version "0.0.2"
  @description "Extends Plug to proxy requests"
  @repo "https://github.com/devpipe/proxy"

  def project do
    [
      app: :ex_proxy,
      version: @version,
      description: @description,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: [
        main: "Proxy",
        source_ref: "v#{@version}",
        source_url: @repo,
        extras: ["README.md"]
      ]
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Wess Cope"],
      links: %{"Github" => @repo}
    }
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.7"},
      {:httpoison, "~> 2.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
