defmodule LocalQueue do
  use Agent

  def start_link(_opts) do
    {:ok, agent} = Agent.start_link(fn -> [] end)
    Process.register(agent, :local_queue)
  end

  def add_order_to_queue(order) do
    Agent.update(:local_queue, LocalQueue, what_to_call_function, [order])
  end

  def add_order_to_queue(queue, _redundant_order, :dont_add) do
    queue
  end
  def add_order_to_queue(queue, new_order, index) do
    List.insert_at(queue, new_order, index)
  end
















  def init(parent_pid) do
    {:ok, pid} = Task.start(fn -> update_queue([], parent_pid))
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
end
