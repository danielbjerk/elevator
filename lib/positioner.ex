defmodule Positioner do

    defp notify_on_position_change(old_position, parent_pid) do  # Notifies parent_pid of position where position is of type {:up/:down/:stop, floor}.
        {old_floor, old_direction} = old_position
        receive do
            direction when direction in [:up, :down, :stop] ->
                send(parent_pid, {old_floor, direction})  
                |> notify_on_position_change(parent_pid)
            floor ->
                send(parent_pid, {floor, old_direction})  
                |> notify_on_position_change(parent_pid)
        end
    end

    def start_positioner(parent_pid) do
        spawn(fn -> notify_on_position_change({0, :stop}, parent_pid) end)
        |> Process.register(:positioner)

        Floor.start_listening_for_floor_changes(:positioner, 0)

    end

end
