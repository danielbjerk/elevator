defmodule Actuator do
  @moduledoc """
  Module for handling orders from elevator related to motor and door.
  """

  def child_spec(pid_parent) do
    %{
      id: Actuator, 
      start: {Actuator, :init, [pid_parent]}
    }
  end

  def init(pid_parent) do
    IO.puts("pid_parent")
    IO.inspect(pid_parent)
    IO.puts("pid_parent")
    {:ok, pid} = Task.start(fn -> handle_messages(pid_parent) end)
  end

  defp handle_messages(pid_parent) do
    receive do
      {:actuator, :door_open, pid_parent} ->
        Door.door_open_wait_until_closing

      {:actuator, {:motor_order, motor_direction}, pid_parent} ->
        :ok = Motor.change_direction(motor_direction)
        send(:positioner, motor_direction)
    end
    handle_messages(pid_parent)
  end
end



defmodule Door do
  @moduledoc """
  Opens door, and closes it after door_wait_for_obstruction_time_ms as long as obstruction isn't active.
  Call Door.door_open_wait_until_closing() to do this, man.
  """

  def door_open_wait_until_closing() do
    door_open()

    :timer.sleep(Constants.door_wait_for_obstruction_time_ms)
    :door_free_to_close = door_wait_until_free_to_close()

    door_close()
  end

  defp door_open() do
    Driver.set_door_open_light(:on)
  end

  defp door_close() do
    Driver.set_door_open_light(:off)
  end

  defp door_wait_until_free_to_close() do
    case Driver.get_obstruction_switch_state() do
      :active ->
        door_wait_until_free_to_close()

      :inactive ->
        :door_free_to_close
    end

  end

end


defmodule Motor do
  def change_direction(motor_direction) do
    Driver.set_motor_direction(motor_direction)
  end
end
