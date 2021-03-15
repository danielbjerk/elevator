defmodule KV.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {KV.Registry, name: KV.Registry},
      Driver,
      {Actuator, name: Actuator},
      {Positioner, name: Positioner},
      #{CabCall, pid_parent}
      #{HallCall, pid_parent}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end 