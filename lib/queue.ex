defmodule Queue do    # Nå er Queue en miks av generelle Q-funksjonaliteter og hvordan vår spesifikke Q samhandler med Agent..
  use Agent

  def start_link(atom_registration_of_queue) do
    #{:ok, agent} = Agent.start_link(Queue, :generate_empty_queue, [], name: __MODULE__) # Doesn't work?
    {:ok, agent} = Agent.start_link(Queue, :generate_empty_queue, [])
    Process.register(agent, atom_registration_of_queue)
  end

  def generate_empty_queue do
    Enum.map(0..Constants.number_of_floors, fn floor -> [{floor, :hall_up, :no_order}, {floor, :hall_down, :no_order}, {floor, :cab, :no_order}] end)
  end

  def get(a_queue) do
    Agent.get(a_queue, fn queue -> queue end)
  end

  def difference(a_queue1, a_queue2) do # Will now return the whole floor where there is a single difference -> fix
    queue1 = get(a_queue1)
    queue2 = get(a_queue2)

    queue_diff = queue1 -- queue2
  end

  def add_order(a_queue, order) do
    Agent.update(a_queue, Queue, :update_order_in_queue, [order])
  end

  def remove_all_orders_to_floor(a_queue, floor) do
    Agent.update(a_queue, Queue, :update_order_in_queue, [{floor, :hall_up, :no_order}])
    Agent.update(a_queue, Queue, :update_order_in_queue, [{floor, :hall_down, :no_order}])
    Agent.update(a_queue, Queue, :update_order_in_queue, [{floor, :cab, :no_order}])
  end

  def update_order_in_queue(queue, order) do
    {floor, order_type, order_here?} = order
    orders_at_floor = Enum.at(queue, floor)
    orders_at_floor_updated = List.replace_at(orders_at_floor, order_type_to_queue_index(order_type), order)
    List.replace_at(queue, floor, orders_at_floor_updated)
  end


  def update_whole_queue(a_queue, new_queue) do   # Works, but does not check that new_queue is actually a queue
    Agent.update(a_queue, fn queue -> new_queue end)
  end


  def order_at_floor?(a_queue, floor) do
    orders_at_floor = Agent.get(a_queue, fn queue -> Enum.at(queue, floor) end)
    ({floor, :hall_up, :order} in orders_at_floor) or ({floor, :hall_down, :order} in orders_at_floor) or ({floor, :cab, :order} in orders_at_floor)
  end

  def get_all_active_orders_at_floor(a_queue, floor) do
    orders_at_floor = Agent.get(a_queue, fn queue -> Enum.at(queue, floor) end)
    Enum.filter(orders_at_floor, fn order ->
      case order do
        {floor, _order_type, :order} -> true
        _ -> false
      end
    end)
  end

"""
# Alternative implementation
  def get_all_active_orders_at_floor(a_queue, floor) do
    orders_at_floor = Agent.get(a_queue, fn queue -> Enum.at(queue, floor) end)
    Enum.flat_map(orders_at_floor, fn order ->
      case order do
        {floor, _order_type, :order} -> order
        {_floor, _order_type, :no_order} -> []
        _ -> :error
      end
    end)
  end

# Alternative alternative implementation
  def get_all_active_orders_at_floor(a_queue, floor) do
    orders_at_floor = Agent.get(a_queue, fn queue -> Enum.at(queue, floor) end)
    list_to_list_of_all_matches(orders_at_floor, {floor, _order_type, :order}, [])
  end

  def list_to_list_of_all_matches([], _match, matches_so_far) do
    matches_so_far
  end
  def list_to_list_of_all_matches(list, match, matches_so_far) do
    [head | tail] = list
    case head do
      match ->
        updated_matches_so_far = [head | matches_so_far]
      _ ->
        updated_matches_so_far = matches_so_far
    end
    list_to_list_of_all_matches(tail, match, updated_matches_so_far)
  end
  """

  def order_type_to_queue_index(order_type) do
    case order_type do
      :hall_up -> 0
      :hall_down -> 1
      :cab -> 2
      _ -> :not_a_order_type
    end
  end




# Heller impllementere kø som liste av maps, hvor hvert map er av typen :order_type -> order?, men da lagrer vi ikke ordre i sin helhet (som består av etasje, ordertype)




"""
  # Mailbox, async approach


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
