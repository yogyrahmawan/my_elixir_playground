"""
parser based on daily drip
"""
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
