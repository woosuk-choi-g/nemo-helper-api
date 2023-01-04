defmodule NemoHelper.RoomWatcher do
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{max_size: 10, data: []})
  end

  def init(state) do
    Process.send_after(self(), :schedule_update, 0)
    {:ok, state}
  end

  def handle_info(:update, state) do
    {:noreply, update(state)}
  end

  def handle_info(:schedule_update, state) do
    data = handle_info(:update, state)
    schedule_update()
    data
  end

  defp schedule_update do
    Process.send_after(self(), :schedule_update, 1000)
  end

  defp update(%{data: data} = state) do
    item = fetch_data()
    data = case data do
      [] -> [item]
      [head | others] ->
        cond do
          item.data != head.data -> [item | data]
          true -> data
        end
    end
    %{state | data: data |> Enum.take(max_size)}
  end

  defp fetch_data do
    url = "https://m16tool.xyz/api/RoomList/GetList"
    resp = HTTPoison.post!(url, "")
    body = Jason.decode!(resp.body)
    Logger.debug "room_size=#{length(body)}"
    item = %{
      timestamp: NemoHelper.TimeUtil.now(),
      data: body
    }
  end

  def handle_call(:get, %{data: data} = state) do
    case data do
      [] -> {:reply, nil, state}
      [head | _] -> {:reply, head, state}
    end
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end
end
