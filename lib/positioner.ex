defmodule Positioner do

    def child_spec(pid_parent) do
        %{
          id: Positioner, 
          start: {Positioner, :start_positioner, [pid_parent]}
        }
    end

    defp notify_on_position_change(old_position, parent_pid) do  # Notifies parent_pid of position where position is of type {:up/:down/:stop, floor}.
        {old_floor, old_direction} = old_position
        receive do
            direction when direction in [:up, :down, :stop] ->
                IO.puts("Aksel")
                send(parent_pid, {old_floor, direction})  
                |> notify_on_position_change(parent_pid)

            floor when is_number(floor) ->
                send(parent_pid, {floor, old_direction})  
                |> notify_on_position_change(parent_pid)
    
            :between_floors ->
                case {old_direction, old_floor} do
                    {:up, old_floor} ->
                        floor = old_floor + 0.5
                        send(parent_pid, {floor, old_direction})
                        |> notify_on_position_change(parent_pid)
                    {:down, old_floor} ->
                        floor = old_floor - 0.5
                        send(parent_pid, {floor, old_direction})
                        |> notify_on_position_change(parent_pid)
                    {:stop, old_floor} ->
                        send(parent_pid, {old_floor, old_direction})
                        |> notify_on_position_change(parent_pid)
                end

            {:invalid, _floor} ->
                IO.puts("Invalid floor received")
        end
    end

    def start_positioner(parent_pid) do
        {:ok, pid} = Task.start(fn -> notify_on_position_change({0, :stop}, parent_pid) end)
        Process.register(pid, :positioner)

        Floor.start_listening_for_floor_changes(:positioner, 0)
        {:ok, pid}
    end

end
