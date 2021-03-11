defmodule LocalQueue do
  use Agent

  def start_link(atom_registration_of_queue) do
    {:ok, agent} = Agent.start_link(LocalQueue, :generate_empty_queue, [], name: __MODULE__)
    Process.register(agent, atom_registration_of_queue)
  end

  defp generate_empty_queue do
    Enum.map(0..Constants.number_of_floors, fn floor -> [{floor, :hall_up, :no_order}, {floor, :hall_down, :no_order}, {floor, :cab, :no_order}] end)
  end

  """
  def add_order(a_queue, order) do
    Agent.update(a_queue, LocalQueue, :replace_order, [order])
  end

  def remove_orders_at_floor(a_queue, floor) do
    Agent.update(a_queue, LocalQueue, replace_order, {floor, _})
  end
  """

  def replace_order(queue, order) do
    {floor, type, order_here?} = order
    orders_at_floor = Enum.at(queue, floor)
    orders_at_floor_updated = Enum.map(orders_at_floor, fn {floor, type, _order_here?} -> order end)
    List.replace_at(queue, floor, orders_at_floor_updated)
  end

  def order_at_floor?(a_queue, floor) do
    orders_at_floor = Agent.get(a_queue, fn queue -> Enum.at(queue, floor) end)
    ({floor, :hall_up, :order} in orders_at_floor) or ({floor, :hall_down, :order} in orders_at_floor) or ({floor, :cab, :order} in orders_at_floor)
  end

  def all_orders_at_floor(a_queue, floor) do
    orders_at_floor = Agent.get(a_queue, fn queue -> Enum.at(queue, floor) end)
    Enum.map(orders_at_floor, fn order -> order == {_, _, :order}, do: order end)
  end












"""


  def init(parent_pid) do
    {:ok, pid} = Task.start(fn -> update_queue([], parent_pid) end)
    Process.register(pid, :local_queue)
  end

  defp update_queue(queue, parent_pid) do
    receive do  # Handle messages

    end
    update_queue(queue, parent_pid)
  end



  def stop_here?(queue, floor_arrival) do   # To be used if queue is to be the one to signalize stopping to the actuators
    [head | tail] = queue
    {floor, type} = head
    floor == floor_arrival
  end

  def get_target_floor([]) do
    :no_target_floor
  end
  def get_target_floor(queue) do
    [{floor, _type} | _tail] = queue
  end

  def order_to_floor_in_queue?(queue, floor) do
    floor in floors_in_queue(queue)
  end

  def floors_in_queue(queue) do
    Enum.map(queue, fn {floor, type} -> floor end)
  end

  def handle_cab_call(queue, new_order, state) do
    {floor, :cab} = new_order
  end

  def index_to_add_order_at(queue, order, state) do

  end

  def add_order_to_queue(queue, _redundant_order, :dont_add) do
    queue
  end
  def add_order_to_queue(queue, new_order, index) do
    List.insert_at(queue, new_order, index)
  end

  """
end
