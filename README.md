# Timeanator

A friendly api for erlang date tuples and ecto datetimes.

## Installation

If [available in Hex](https://hex.pm/packages/timeanator), the package can be installed as:

  1. Add `timeanator` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:timeanator, "~> 0.0.1"}]
    end
    ```

## Usage

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
