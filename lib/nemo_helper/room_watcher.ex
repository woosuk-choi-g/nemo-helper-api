defmodule NemoHelper.RoomWatcher do
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{max_size: 10, data: []})
  end

  def init(state) do
    schedule_update()
    {_, state} = handle_info(:update, state)
    {:ok, state}
  end

  def handle_info(:update, %{max_size: max_size, data: data} = state) do
    with {:ok, resp} <- fetch_rooms(),
      {:ok, body} <- Jason.decode(resp.body) do
        item = %{
          timestamp: NemoHelper.TimeUtil.now(),
          data: body
        }
        Logger.debug "map_size=#{length(body)}"

        data = [item | data] |> Enum.take(max_size)
        {:noreply, %{state | data: data}}
    else
      {:error, error} ->
        Logger.error inspect(error)
        {:noreply, state}
    end
  end

  def handle_info(:schedule_update, state) do
    schedule_update()
    handle_info(:update, state)
  end

  defp schedule_update do
    Process.send_after(self(), :schedule_update, 1000)
  end

  defp fetch_rooms() do
    url = "https://m16tool.xyz/api/RoomList/GetList"
    HTTPoison.post(url, "", [{"Accept", "application/json"}])
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
