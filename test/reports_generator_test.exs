defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "builds a report" do
      filenames = "report_test.csv"

      result =
        filenames
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
      filenames = "report_test.csv"
      kind = "users"

      result =
        filenames
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost(kind)

      expected_result = {:ok, {"5", 49}}

      assert result == expected_result
    end

    test "it should return the most consumed dish, if kind is equal to 'dishs'" do
      filenames = "report_test.csv"
      kind = "dishs"

      result =
        filenames
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost(kind)

      expected_result = {:ok, {"esfirra", 3}}

      assert result == expected_result
    end

    test "it should return an error, if kind is not a valid value" do
      filenames = "report_test.csv"
      kind = "foo"

      result =
        filenames
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher_cost(kind)

      expected_result = {:error, "Invalid kind!"}

      assert result == expected_result
    end
  end

  describe "build_bulk/1" do
    test "it should return a report when a valid list of filenames is provided" do
      filenames = ["report_test.csv", "report_test.csv"]

      result =
        filenames
        |> ReportsGenerator.build_bulk()

      expected_result =
        {:ok,
         %{
           "dishs" => %{
             "açaí" => 2,
             "churrasco" => 4,
             "esfirra" => 6,
             "hambúrguer" => 4,
             "pastel" => 0,
             "pizza" => 4,
             "prato_feito" => 0,
             "sushi" => 0
           },
           "users" => %{
             "1" => 96,
             "10" => 72,
             "11" => 0,
             "12" => 0,
             "13" => 0,
             "14" => 0,
             "15" => 0,
             "16" => 0,
             "17" => 0,
             "18" => 0,
             "19" => 0,
             "2" => 90,
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
             "3" => 62,
             "30" => 0,
             "4" => 84,
             "5" => 98,
             "6" => 36,
             "7" => 54,
             "8" => 50,
             "9" => 48
           }
         }}

      assert result == expected_result
    end

    test "it should return an error if a list of strings isn't provided" do
      result = ReportsGenerator.build_bulk("foo")

      expected_result = 0

      assert result == {:error, "filenames must be a valid list of strings"}
    end
  end
end
