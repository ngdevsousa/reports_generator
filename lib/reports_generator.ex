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

  def fetch_higher_cost(report, kind) when kind in @kinds do
    {:ok, Enum.max_by(report[kind], fn {_k, v} -> v end)}
  end

  def fetch_higher_cost(_report, _kind), do: {:error, "Invalid kind!"}

  defp report_acc do
    dishs = Enum.into(@available_dishs, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    %{"users" => users, "dishs" => dishs}
  end

  defp sum_values([id, dish_name, price], %{"dishs" => dishs, "users" => users} = report) do
    users = Map.put(users, id, price + users[id])
    dishs = Map.put(dishs, dish_name, dishs[dish_name] + 1)

    %{report | "users" => users, "dishs" => dishs}
  end
end
