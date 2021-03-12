defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "builds a report" do
      file_name = "report_test.csv"

      result =
        file_name
        |> ReportsGenerator.build()

      expected_result = %{
        "dishs" => %{
          "açaí" => 1,
          "churrasco" => 2,
          "esfirra" => 3,
          "hambúrguer" => 2,
          "pastel" => 0,
          "pizza" => 2,
          "prato_feito" => 0,
          "sushi" => 0
        },
        "users" => %{
          "1" => 48,
          "10" => 36,
          "11" => 0,
          "12" => 0,
          "13" => 0,
          "14" => 0,
          "15" => 0,
          "16" => 0,
          "17" => 0,
          "18" => 0,
          "19" => 0,
          "2" => 45,
          "20" => 0,
          "21" => 0,
          "22" => 0,
          "23" => 0,
          "24" => 0,
          "25" => 0,
          "26" => 0,
          "27" => 0,
          "28" => 0,
          "29" => 0,
          "3" => 31,
          "30" => 0,
          "4" => 42,
          "5" => 49,
          "6" => 18,
          "7" => 27,
          "8" => 25,
          "9" => 24
        }
      }

      assert result == expected_result
    end
  end

  describe "fetch_higher_cost/2" do
    test "it should return the user who spent the most, if kind is equal to 'users'" do
      file_name = "report_test.csv"
      kind = "users"

      result =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost(kind)

      expected_result = {:ok, {"5", 49}}

      assert result == expected_result
    end

    test "it should return the most consumed dish, if kind is equal to 'dishs'" do
      file_name = "report_test.csv"
      kind = "dishs"

      result =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost(kind)

      expected_result = {:ok, {"esfirra", 3}}

      assert result == expected_result
    end

    test "it should return an error, if kind is not a valid value" do
      file_name = "report_test.csv"
      kind = "foo"

      result =
        file_name
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost(kind)

      expected_result = {:error, "Invalid kind!"}

      assert result == expected_result
    end
  end
end
