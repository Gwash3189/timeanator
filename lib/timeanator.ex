defmodule Timeanator do
  @milliseconds_in_second 1000
  @milliseconds_in_minute 60000
  @millieseconds_in_hour 3600000
  @hours_in_day 24

  @moduledoc """

  This module provides a friendly API for getting time represented
  in milliseconds.

  ```
    import Timeanator
    1 |> minute #=> 60000
    30 |> Timeanator.minutes #=> 1800000
  ```

  additionally, when methods `from_now` or `ago` are used erlang time tuples
  are provided

  ```
  import Timeanator
  15 |> minutes |> ago #=> {:ok, {{2019, 11, 4}, {1, 24, 14}}}
  15 |> minutes |> from_now #=> {:ok, {{2019, 11, 4}, {1, 54, 24}}}
  ```

  `from_now` and `ago` can return `Ecto.DateTime` structs. This is done by
  providing the `:ecto` atom to either the `from_now` or `ago` functions

  ```
  import Timeanator
  15 |> minutes |> ago(:ecto) #=> {:ok, #Ecto.DateTime<2019-11-04 01:24:37>}
  15 |> minutes |> from_now(:ecto) #=> {:ok, #Ecto.DateTime<2019-11-04 01:54:38>}
  ```

  Lastly, there are `from_now!` and `ago!` variants that raise either
  `Timeanator.Cast` or `Timeanator.UnsupportedCastingOption` exceptions. They also
  *do not* return a `{:ok, value}` tuple, but instead just return `value`
  """

  @doc """
    returns the amount provided in milliseconds
  """
  @spec millisecond(integer) :: integer
  def millisecond(1), do: 1

  @doc """
    returns the amount provided in milliseconds
  """
  @spec milliseconds(integer) :: integer
  def milliseconds(int), do: int

  @doc """
    returns one second in milliseconds
  """
  @spec second(integer) :: integer
  def second(1), do:
    seconds(@milliseconds_in_second)

  @doc """
    returns the amount of seconds provided in milliseconds
  """
  @spec seconds(integer) :: integer
  def seconds(int), do:
    milliseconds(int * @milliseconds_in_second)

  @doc """
    returns one minute in milliseconds
  """
  @spec minute(integer) :: integer
  def minute(1), do:
    minutes(1)

  @doc """
    returns the amount provided in milliseconds
  """
  @spec minutes(integer) :: integer
  def minutes(int), do:
    int * @milliseconds_in_minute

  @doc """
    returns one hour in milliseconds
  """
  @spec hour(integer) :: integer
  def hour(1), do:
    hours(1)

  @doc """
    returns the amount provided in milliseconds
  """
  @spec hours(integer) :: integer
  def hours(int), do:
    int * @millieseconds_in_hour

  @doc """
    returns one day in milliseconds
  """
  @spec day(integer) :: integer
  def day(1), do:
    days(1)

  @doc """
    returns the amount provided in milliseconds
  """
  @spec days(integer) :: integer
  def days(int), do:
    @hours_in_day * int |> hours

  @doc """
    returns a erlang date that is X milliseconds in the future.
  """
  @spec from_now(integer, :ecto | nil) :: {:ok, :calendar.datetime} | {:ok, %Ecto.DateTime{}} | {:error, atom}
  def from_now(milliseconds, cast_option \\ nil) when is_integer(milliseconds) do
    Timex.now
      |> Timex.shift(milliseconds: milliseconds)
      |> Timex.to_erl
      |> do_cast(cast_option)
  end

  @doc """
    returns a erlang date that is X milliseconds in the future. Raises if there is a problem
  """
  @spec from_now(integer, :ecto | nil) :: :calendar.datetime | %Ecto.DateTime{}
  def from_now!(milliseconds, cast_options \\ nil) when is_integer(milliseconds) do
    case from_now(milliseconds, cast_options) do
      {:error, message} -> throw message
      {:ok, value} -> value
    end
  end

  @doc """
    returns a erlang date that is X milliseconds in the past.
  """
  @spec ago(integer, :ecto | nil) :: {:ok, :calendar.datetime} | {:ok, %Ecto.DateTime{}} | {:error, atom}
  def ago(milliseconds, cast_option \\ nil) when is_integer(milliseconds), do:
    from_now(milliseconds - (milliseconds * 2), cast_option)

  @doc """
    returns a erlang date that is X milliseconds in the past. Raises if there is a problem
  """
  @spec ago!(integer, :ecto | nil) :: :calendar.datetime | %Ecto.DateTime{}
  def ago!(milliseconds, cast_option \\ nil) when is_integer(milliseconds) do
    case ago(milliseconds, cast_option) do
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
