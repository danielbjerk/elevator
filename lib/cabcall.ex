defmodule CabCall do
    @moduledoc """
    Module for starting and recieving orders from inside the elevator.
    """

    def child_spec(pid_parent) do
        %{
          id: CabCall, 
          start: {CabCall, :init, [pid_parent]}
        }
    end

    def init(pid_parent) do
        start_all_buttons(pid_parent,Constants.number_of_floors)
    end

    defp start_all_buttons(_pid_parent, -1) do
        :ok
    end
    defp start_all_buttons(pid_parent,next_floor) do
        {:ok, _pid_button} = HWButton.start_reporting(pid_parent, :cab, next_floor)
        start_all_buttons(pid_parent,next_floor - 1)
    end
end

defmodule HWButton do
    @moduledoc """
    Module for implementing "interrupts" from the elevator into elixir in the form of standardized messages
    """

    def start_reporting(pid_parent, button_type, floor) do
        Task.start(fn -> state_change_reporter(pid_parent, button_type, floor, :init) end)
    end

    defp state_change_reporter(pid_parent, :stop_button, _floor, last_state) do
        new_state = Driver.get_stop_button_state
        if new_state !== last_state, do: send(pid_parent, {:hw_button, {:stop_button, :not_a_floor, new_state}, self()})
        state_change_reporter(pid_parent, :stop_button, :not_a_floor, new_state)
    end

    defp state_change_reporter(pid_parent, button_type, floor, last_state) do
        new_state = Driver.get_order_button_state(floor, button_type)
        if new_state !== last_state, do: send(pid_parent, {:hw_button, {button_type, floor, new_state}, self()})
        state_change_reporter(pid_parent, button_type, floor, new_state)
    end
end
