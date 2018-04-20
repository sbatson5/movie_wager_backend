defmodule MovieWagerBackend.BoxOfficeCollector do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    MovieWagerBackend.Movie.BoxofficeMojo.update_rounds_without_amounts()

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # Poll every 24 hours
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000)
  end
end
