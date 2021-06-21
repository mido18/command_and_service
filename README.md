# CommandAndService

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `command_and_service` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:command_and_service, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/command_and_service](https://hexdocs.pm/command_and_service).

to calculate the path for a specific route
```elixir
path = [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}]
CommandAndService.calculate_fuel_for_path(28801, path) # 51898

```