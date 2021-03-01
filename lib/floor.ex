defmodule Floor do

    def listen_for_floor_changes(parent_pid, old_floor) do
        case {Driver.get_floor_sensor_state, old_floor} do
            {floor, floor} ->   # No change.
                listen_for_floor_changes(parent_pid, floor)
            {:between_floors, _last_floor} ->    # Moved to between floors.
                send(parent_pid, :between_floors)
                listen_for_floor_changes(parent_pid, :between_floors)
            {new_floor, _last_floor} ->  # Moved to new floor.
                send(parent_pid, new_floor)
                listen_for_floor_changes(parent_pid, new_floor)
        end
    end

    def start_listening_for_floor_changes(parent_pid, initial_floor) do # Spawns process which listens to changes in current floor and sends these to parent_pid.
        spawn(fn -> listen_for_floor_changes(parent_pid, initial_floor) end)
    end

end