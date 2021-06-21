defmodule CommandAndService.CLI do
  use ExCLI.DSL, escript: true

  name "command_and_service"
  description "My command and service cli"
  long_description ~s"""
  adding comment on how to use it
  """

  option :verbose, count: true, aliases: [:v]
  command :calculate_fuel do
    aliases [:cf]
    description "calculate the needed fuel"
    long_description """
    returns the number for user
    """

    argument :mass, help: "the initial mass for the ship"
    argument :commands, help: "the route path that the ship will take"

    run context do
      if context.verbose > 0 do
        IO.puts("Running fuel calculator")
      end
      context.mass
      |> CommandAndService.calculate_fuel_for_path(context.commands)
      |> IO.puts()
    end
  end
end
