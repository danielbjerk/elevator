defmodule Motor do
  @moduledoc """

  """

  import Driver

  def motor_init(pid_parent) do   # Eksternt interfjes, resten av kommunikasjonen skjer med send/recv til pid_motor (custom pid her?)
    {:ok, pid_motor} = Task.start(motor_execute_orders(pid_parent))
  end

  defp motor_execute_orders() do
    recieve do
      {:actuator, order, _} -> motor_begin_driving(order)
    end
  end

  def motor_begin_driving(order) do

  end

end
