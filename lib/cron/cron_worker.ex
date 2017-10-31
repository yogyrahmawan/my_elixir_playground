defmodule Cron.Worker do 
  use GenServer 
  
  @interval 60_000 

  def start_link(:ok) do 
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_schedule(string) do 
    :ok = GenServer.cast(Cron.Worker, {:add_schedule, string})
  end

  def clear_schedule do 
    :ok = GenServer.cast(Cron.Worker, :clear_schedule)
  end

  # Server callback 
  def init(_) do 
    :timer.send_interval(@interval, self, :tick)
    {:ok, []}
  end

  def handle_cast({:add_schedule, str}, schedules) do 
    schedule = Cron.Parser.parse(str)
    {:noreply, [schedule | schedules]}
  end 

  def handle_cast(:clear_schedule, _schedules) do 
    {:noreply, []}
  end

  def handle_info(:tick, schedules) do 
    current_time = GoodTimes.now 

    for schedule <- schedules do 
      if Cron.Schedule.include?(schedule, current_time) do 
        Cron.Schedule.execute_command(schedule)
      end
    end 
    {:noreply, schedules}
  end

  @spec execute_command(Cron.Schedule) :: any
  def execute_command(%Cron.Schedule{command: command}) do 
    spawn(fn() -> Code.eval_quoted(command) end)
  end
end
