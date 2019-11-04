# Timeanator

A friendly api for erlang date tuples and ecto datetimes.

## Installation

If [available in Hex](https://hex.pm/packages/timeanator), the package can be installed as:

  1. Add `timeanator` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:timeanator, "~> 1.0.0"}]
    end
    ```

## Usage

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
