defmodule Elevator do 
  @moduledoc """
  The "brain" or communication module 
  """

  def init() do 
    message_handler(:init_floor, :init_floor)
  end

  defp message_handler(target_floor, current_floor) do

    receive do        
        {:queue, target_floor} ->  send(:actuator, {:actuator, {:motor_order, calculate_target_vs_current(target_floor, current_floor)}, self()})
        {:cab_call, cab_call} -> send(:queue, {:queue, {:cab_call, cab_call}, self()})
        {:positioner, {:positioner_state, positioner_state}} -> send(:queue, {:queue, {:positioner_state, positioner_state}, self()}) 
    end
    message_handler(target_floor, current_floor)

  end

  defp calculate_target_vs_current(target_floor, current_floor) do
    
    cond  do
        target_floor > current_floor -> 
            :up
        target_floor < current_floor -> 
            :down
        target_floor == current_floor -> 
            :stop
    end
  end
end
