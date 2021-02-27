defmodule Door do
  @moduledoc """
  Opens door, and closes it after @door_wait_for_obstruction_time_ms as long as obstruction isn't active.
  Call Door.door_open_wait_until_closing() to do this, man.
  """

  @door_wait_for_obstruction_time_ms 5000

  import Driver

  def door_open_wait_until_closing() do
    door_open()

    :timer.sleep(@door_wait_for_obstruction_time_ms)
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
