defmodule CabCall do
    @moduledoc """
    Takes order from inside elevator. This is only a an integrer, the floor number. 
    """
    import Driver
    @number_of_floors

    def spawn_floor_read(0) do
        :spawned_all_floors
    end


    def spawn_floor_read(floor) do
        spawn fn -> read_button(floor, pid)
        spawn_floor_read(floor-1)
    end


    defp read_and_send_button_state(floor, pid) do
        case Driver.get_order_button_state(floor, :cab)
            :on -> 
                Driver.set_order_button_light(:cab, floor, :on)
                send(pid, floor) # Send floor til sensor
                read_button(floor, pid)
            
            :off -> read_button(floor, pid) 

        end
    end
