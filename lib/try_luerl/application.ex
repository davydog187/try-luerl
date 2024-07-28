defmodule TryLuerl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TryLuerlWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:try_luerl, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TryLuerl.PubSub},
      # Start a worker by calling: TryLuerl.Worker.start_link(arg)
      # {TryLuerl.Worker, arg},
      # Start to serve requests, typically the last entry
      TryLuerlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TryLuerl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TryLuerlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
