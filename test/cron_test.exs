"""
parsing cron schedule 
based on learning on dailydrip
"""
defmodule Cron.Schedule do 
  defstruct [:minute, :hour, :day_of_week, :day_of_month, :month, :command]
end

defmodule Cron.Parser do 
  def parse(string) do 
    [minute, hour, day_of_month, month, day_of_week | command] = String.split(string)
    cmd_str = Enum.join(command) 
    {:ok, cmd} = Code.string_to_quoted(cmd_str)
    parse(minute, hour, day_of_month, month, day_of_week, cmd)
  end

  def parse(minute, hour, day_of_month, month, day_of_week, command) do 
    %Cron.Schedule{minute: parse_pattern(minute, 0..59), hour: parse_pattern(hour, 0..11), day_of_month: parse_pattern(day_of_month, 1..31), month: parse_pattern(month, 1..12), day_of_week: parse_pattern(day_of_week, 0..6), command: command}
  end

  def parse_pattern("*", range) do
    Enum.to_list(range)
  end

  def parse_pattern("*/" <> mod, range) do
    mod = String.to_integer(mod)
    Enum.filter(range, fn(i) -> 
      rem(i,mod) == 0 
    end)
  end

  def parse_pattern(pattern, _range) do 
    pattern 
    |> String.split(",")
    |> Enum.map(
      &
      (
        &1 
        |> String.to_integer
      )
    )
  end 

end

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
end
