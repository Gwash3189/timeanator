defmodule Timeanator do
  @minutes_in_hour 60
  @seconds_in_minute 60
  @hours_in_day 24

  @moduledoc """

  This module provides a friendly API for getting time represented
  in seconds.

  ```
    import Timeanator
    1 |> minute #=> 60
    30 |> Timeanator.minutes #=> 1800
  ```

  additionally, when methods `from_now` or `ago` are used erlang time tuples
  are provided

  ```
  import Timeanator
  15 |> minutes |> ago #=> {:ok, {{2016, 11, 3}, {9, 59, 38}}}
  15 |> minutes |> from_now #=> {:ok, {{2016, 11, 3}, {10, 31, 13}}}
  ```

  `from_now` and `ago` can return `Ecto.DateTime` structs. This is done by
  providing the `:ecto` atom to either the `from_now` or `ago` functions

  ```
  import Timeanator
  15 |> minutes |> ago(:ecto) #=> {:ok, #Ecto.DateTime<2016-11-03 20:59:42>}
  15 |> minutes |> from_now(:ecto) #=> {:ok, #Ecto.DateTime<2016-11-03 22:00:31>}
  ```

  Lastly, there are `from_now!` and `ago!` variants that raise either
  `Timeanator.Cast` or `Timeanator.UnsupportedCastingOption` exceptions. They also
  *do not* return a `{:ok, value}` tuple, but instead just return `value`
  """

  @doc """
    returns one second
  """
  @spec second(integer) :: integer
  def second(1), do:
    seconds(1)

  @doc """
    returns the amount provided in seconds
  """
  @spec seconds(integer) :: integer
  def seconds(int), do:
    int

  @doc """
    returns one minute in seconds
  """
  @spec minute(integer) :: integer
  def minute(1), do:
    minutes(1)

  @doc """
    returns the amount provided in seconds
  """
  @spec minutes(integer) :: integer
  def minutes(int), do:
    int * @seconds_in_minute

  @doc """
    returns one hour in seconds
  """
  @spec hour(integer) :: integer
  def hour(1), do:
    hours(1)

  @doc """
    returns the amount provided in seconds
  """
  @spec hours(integer) :: integer
  def hours(int), do:
    int * @minutes_in_hour * @seconds_in_minute

  @doc """
    returns one day in seconds
  """
  @spec day(integer) :: integer
  def day(1), do:
    days(1)

  @doc """
    returns the amount provided in seconds
  """
  @spec days(integer) :: integer
  def days(int), do:
    @hours_in_day * int |> hours

  @doc """
    returns a erlang date that is X seconds in the future.
  """
  @spec from_now(integer, :ecto | nil) :: {:ok, :calendar.datetime} | {:ok, %Ecto.DateTime{}} | {:error, atom}
  def from_now(seconds, cast_option \\ nil) when is_integer(seconds) do
    Timex.now
      |> Timex.shift(seconds: seconds)
      |> Timex.to_erl
      |> do_cast(cast_option)
  end

  @doc """
    returns a erlang date that is X seconds in the future. Raises if there is a problem
  """
  @spec from_now(integer, :ecto | nil) :: :calendar.datetime | %Ecto.DateTime{}
  def from_now!(seconds, cast_options \\ nil) when is_integer(seconds) do
    case from_now(seconds, cast_options) do
      {:error, message} -> throw message
      {:ok, value} -> value
    end
  end

  @doc """
    returns a erlang date that is X seconds in the past.
  """
  @spec ago(integer, :ecto | nil) :: {:ok, :calendar.datetime} | {:ok, %Ecto.DateTime{}} | {:error, atom}
  def ago(seconds, cast_option \\ nil) when is_integer(seconds), do:
    from_now(seconds - (seconds * 2), cast_option)

  @doc """
    returns a erlang date that is X seconds in the past. Raises if there is a problem
  """
  @spec ago!(integer, :ecto | nil) :: :calendar.datetime | %Ecto.DateTime{}
  def ago!(seconds, cast_option \\ nil) when is_integer(seconds) do
    case ago(seconds, cast_option) do
      {:error, message} -> raise message
      {:ok, value} -> value
    end
  end


  defp do_cast(value, nil), do: {:ok, value}
  defp do_cast(value, cast_option) do
    case cast_option do
      :ecto -> Ecto.DateTime.cast(value) |> handle_cast
      _ -> handle_cast(:unsupported_cast_option)
    end
  end

  defp handle_cast(:error), do:
    {:error, Timeanator.Cast}
  defp handle_cast({:ok, value}), do:
    {:ok, value}
  defp handle_cast(:unsupported_cast_option), do:
    {:error, Timeanator.UnsupportedCastingOption}
end
