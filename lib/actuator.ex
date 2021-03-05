defmodule Actuator do
  @moduledoc """
  Module for handling orders from elevator related to motor and door.
  """

  def init(pid_parent) do
    {:ok, pid} = Task.start(fn -> handle_messages(pid_parent) end)
  end

  defp handle_messages(pid_parent) do
    receive do
      {:actuator, :door_open, pid_parent} ->
        Door.door_open_wait_until_closing

      {:actuator, {:motor_order, motor_direction}, pid_parent} ->
        Motor.order_direction(motor_direction)
    end
    handle_messages(pid_parent)
  end
end
