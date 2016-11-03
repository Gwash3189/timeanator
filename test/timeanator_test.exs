defmodule TimeanatorTest do
  use ExUnit.Case
  import Timeanator

  describe "seconds" do
    test "it returns two seconds in seconds" do
      value = 2 |> seconds

      assert value == 2
    end
  end

  describe "minutes" do
    test "it returns two minutes in seconds" do
      value = 2 |> minutes

      assert value == 120
    end
  end

  describe "hours" do
    test "it returns two hours in seconds" do
      value = 2 |> hours

      assert value == 7_200
    end
  end

  describe "days" do
    test "it returns two days in seconds" do
      value = 2 |> days

      assert value == 172_800
    end
  end

  describe "from_now" do
    test "it returns an {:ok, value} tuple" do
      assert {:ok, _} = 2 |> days |> from_now
    end
  end

  describe "from_now(:ecto)" do
    test "it returns an Ecto.DateTime" do
      assert {:ok, %Ecto.DateTime{}} = 2 |> days |> from_now(:ecto)
    end
  end

  describe "ago" do
    test "it returns an {:ok, value} tuple" do
      assert {:ok, _} = 2 |> days |> ago
    end
  end

  describe "ago(:ecto)" do
    test "it returns an Ecto.DateTime" do
      assert {:ok, %Ecto.DateTime{}} = 2 |> days |> ago(:ecto)
    end
  end
end
