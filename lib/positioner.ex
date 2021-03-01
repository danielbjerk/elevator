defmodule Positioner do

    def notify_on_position_change(parent_pid, old_position) do  # Notifies parent_pid of position where position is of type {:moving_up/:moving_down/:stationary, floor}.
        case old_position do
            {old_floor, old_direction} when old_floor != :unknown ->    # Position (floor and direction) is known.
                send(parent_pid, old_position)
                notify_on_position_change(parent_pid, {:unknown, old_direction})

            {old_floor, old_direction} ->   # At least one of floor and direction is not known.
                receive do
                    direction when direction in [:moving_up, :moving_down, :stationary] ->
                        notify_on_position_change(parent_pid, {old_floor, direction})
                    floor ->
                        notify_on_position_change(parent_pid, {floor, old_direction})
                end
        end
    end       

    def start_positioner(parent_pid) do
        positioner_id = spawn(fn -> notify_on_position_change(parent_pid, {:stationary, 0}) end)
        #Registry.start_link({positioner_id, "positioner"})
        Floor.start_listening_for_floor_changes(positioner_id, 0)
    end


end