defmodule ExDebugToolbar.Collector.EctoCollector do
  alias ExDebugToolbar.Toolbar
  alias Ecto.LogEntry

  def log(%LogEntry{} = entry) do
    {id, duration} = parse_entry(entry)
    Toolbar.add_finished_event(id, "ecto.query", duration)
    Toolbar.add_data(id, :ecto, {entry, duration})
    entry
  end

  defp parse_entry(entry) do
    case entry do
      %{caller_pid: pid} when not is_nil(pid) ->
        {pid, 0}
      _ ->
        duration = (entry.queue_time || 0) + (entry.query_time || 0) + (entry.decode_time || 0)
        {self(), duration}
    end
  end
end
