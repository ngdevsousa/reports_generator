alias ReportsGenerator.Parser

defmodule ReportsGenerator do
  def build(filename) do
    filename
    |> Parser.from_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  defp report_acc, do: Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

  defp sum_values([id, _dish, price], report), do: Map.put(report, id, price + report[id])
end
