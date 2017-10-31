defmodule CronTest do 
  use ExUnit.Case

  @command Code.string_to_quoted!("Module.function(:arg1)")
  @command2 Code.string_to_quoted!("Module.function(:arg2, :arg3)")

  test "parsing a schedule string" do 
    assert Cron.Parser.parse("0 0 0 0 0 Module.function(:arg1)") == %Cron.Schedule{minute: [0], hour: [0], day_of_month: [0], month: [0], day_of_week: [0], command: @command}
    assert Cron.Parser.parse("1 0 0 0 0 Module.function(:arg2, :arg3)") == %Cron.Schedule{minute: [1], hour: [0], day_of_month: [0], month: [0], day_of_week: [0], command: @command2}
  end

  test "multiple minutes" do 
    assert Cron.Parser.parse("1,2 0 0 0 0 Module.function(:arg2, :arg3)") == %Cron.Schedule{minute: [1, 2], hour: [0], day_of_month: [0], month: [0], day_of_week: [0], command: @command2}

  end
  
  test "parsing a wildcard" do 
    assert Cron.Parser.parse("0 0 0 0 * Module.function(:arg1)") == %Cron.Schedule{minute: [0], hour: [0], day_of_month: [0], month: [0], day_of_week: [0, 1, 2, 3, 4, 5, 6], command: @command}
  end

  test "parsing patterns like 'every five minutes'" do
    assert Cron.Parser.parse("*/5 0 0 0 * Module.function(:arg1)") == %Cron.Schedule{minute: [0,5,10,15,20,25,30,35,40,45,50,55], hour: [0], day_of_month: [0], month: [0], day_of_week: [0,1,2,3,4,5,6], command: @command}
  end
  
  @tag timeout: 80000
  test "add command" do 
    pid_list = :erlang.pid_to_list(self)
    Cron.add_schedule("* * * * * send(:erlang.list_to_pid(#{inspect pid_list}), :ok)")
    :timer.sleep(30000)
    Cron.clear_schedule
    :timer.sleep(31000)
    refute_received(:ok)
  end  
end
