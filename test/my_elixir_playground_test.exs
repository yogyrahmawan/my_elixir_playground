defmodule MyElixirPlaygroundTest do
  use ExUnit.Case
  doctest MyElixirPlayground

  test "greets the world" do
    assert MyElixirPlayground.hello() == :world
  end
end
