defmodule TechstackNews.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      %{
        id: NodeJS,
        start: {NodeJS, :start_link, [[path: "./assets", pool_size: 4]]}
      },
      # Start the Ecto repository
      TechstackNews.Repo,
      # Start the Telemetry supervisor
      TechstackNewsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TechstackNews.PubSub},
      # Start the Endpoint (http/https)
      TechstackNewsWeb.Endpoint,
      TechstackNews.Scheduler
      # Start a worker by calling: TechstackNews.Worker.start_link(arg)
      # {TechstackNews.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TechstackNews.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TechstackNewsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
