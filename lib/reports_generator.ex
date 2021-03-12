alias ReportsGenerator.Parser

defmodule ReportsGenerator do
  @available_dishs [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @kinds ["dishs", "users"]

  def build(filename) do
    filename
    |> Parser.from_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build_bulk(filenames) when not is_list(filenames),
    do: {:error, "filenames must be a valid list of strings"}

  def build_bulk(filenames) do
    result = filenames
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_acc(), fn {:ok, result}, report -> sum_reports(report, result) end)

    {:ok, result}
  end

  def fetch_higher_cost(report, kind) when kind in @kinds do
    {:ok, Enum.max_by(report[kind], fn {_k, v} -> v end)}
  end

  def fetch_higher_cost(_report, _kind), do: {:error, "Invalid kind!"}

  defp report_acc do
    dishs = Enum.into(@available_dishs, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    build_report_map(dishs, users)
  end

  defp sum_values([id, dish_name, price], %{"dishs" => dishs, "users" => users}) do
    users = Map.put(users, id, price + users[id])
    dishs = Map.put(dishs, dish_name, dishs[dish_name] + 1)

    build_report_map(dishs, users)
  end

  defp sum_reports(%{"dishs" => new_dishs, "users" => new_users}, %{
         "dishs" => final_dishs,
         "users" => final_users
       }) do
    dishs = merge_maps(new_dishs, final_dishs)
    users = merge_maps(new_users, final_users)

    build_report_map(dishs, users)
  end

  defp merge_maps(new_map, final_map) do
    Map.merge(new_map, final_map, fn _k, new_value, final_value -> new_value + final_value end)
  end

  defp build_report_map(dishs, users), do: %{"dishs" => dishs, "users" => users}
end
