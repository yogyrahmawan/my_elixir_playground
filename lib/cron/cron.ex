defmodule Cron do 
  use Application 

  def start(_type, _args) do 
    import Supervisor.Spec, warn: false

    children = [
      worker(Cron.Worker, [:ok])
    ]

    opts = [strategy: :one_for_one, none: Cron.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defdelegate add_schedule(schedule), to: Cron.Worker 
  defdelegate clear_schedule, to: Cron.Worker
end 
