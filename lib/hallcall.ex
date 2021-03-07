defmodule HallCall do
  @moduledoc """
    Module for starting and recieving orders from outside the elevator.
    """

    def init(pid_parent) do
      start_all_buttons(pid_parent,Constants.number_of_floors)
  end

  defp start_all_buttons(_pid_parent, -1) do
      :ok
  end
  defp start_all_buttons(pid_parent,next_floor) do
      {:ok, _pid_button} = HWButton.start_reporting(pid_parent, :hall_up, next_floor)
      {:ok, _pid_button} = HWButton.start_reporting(pid_parent, :hall_down, next_floor)
      start_all_buttons(pid_parent,next_floor - 1)
  end
end
