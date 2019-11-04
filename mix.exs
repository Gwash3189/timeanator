defmodule Timeanator.Mixfile do
  use Mix.Project

  @description """
    A friendly api for erlang date tuples and ecto datetimes.
  """

  def project do
    [app: :timeanator,
     version: "0.0.2",
     elixir: "~> 1.9",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     name: "Timeanator",
     description: @description,
     package: package(),
     source_url: "https://github.com/Gwash3189/timeanator",
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:timex]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:timex, "~> 3.5"},
      {:ecto, "~> 2.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
   ]
  end

  defp package do
    [
      maintainers: ["Adam Beck"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Gwash3189/timeanator"}
    ]
  end
end
