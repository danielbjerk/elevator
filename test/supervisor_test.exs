defmodule SUPERVISORTest do
  use ExUnit.Case
  doctest SUPERVISOR

  test "greets the world" do
    assert SUPERVISOR.hello() == :world
  end
end
