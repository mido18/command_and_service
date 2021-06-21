defmodule CommandAndService do
  @moduledoc """
  Documentation for `CommandAndService`.
  """

  @type operation_gravity() :: {atom(), integer()}

  #  @doc """
  #  tuplaize_args
  #
  #  ## Examples
  #
  #    iex> CommandAndService.tuplaize_args(":launch, 9.807")
  #    {:launch, 9.807}
  #
  #  """

  @spec sanatize(String.t()) :: operation_gravity()
  defp tuplaize_args(str) do
    [str_launch, str_gravity] =
      str
      |> String.slice(1..-1)
      |> String.replace(" ", "")
      |> String.split(",")

    {gravity, ""} = Float.parse(str_gravity)
    launch = String.to_atom(str_launch)
    {launch, gravity}
  end

  #  @doc """
  #  sanatize
  #
  #  ## Examples
  #
  #    iex> CommandAndService.tuplaize_args("[[:launch, 9.807], [:land, 1.62], [:launch, 1.62], [:land, 9.807]]")
  #    [launch: 9.807, land: 1.62, launch: 1.62, land: 9.807]
  #
  #  """
  @spec sanatize(String.t()) :: list(operation_gravity())
  defp sanatize(commands) do
    string_commands =
      commands
      |> String.slice(1..-1)
      |> String.reverse()
      |> String.slice(1..-1)
      |> String.reverse()

    ~r/\[+(.*?)\]+/
    |> Regex.scan(string_commands)
    |> Enum.map(fn [_ , element]->
      tuplaize_args(element)
    end)
  end

  #  @doc """
  #  Round number down
  #
  #  ## Examples
  #
  #    iex> CommandAndService.round_down(10.9)
  #    10
  #
  #    iex> CommandAndService.round_down(10.2)
  #    10
  #  """
  @spec round_down(integer()) :: integer()
  defp round_down(number), do: Float.floor(number) |> trunc()

  #  @doc """
  #  equation for calculating the fuel needed for launch
  #
  #  ## Examples
  #
  #    iex> calculation(:launch, 28801, 9.807)
  #    11829.959094000002
  #
  #  """
  @spec calculation(atom(), integer(), float()) :: float
  defp calculation(:launch, mass, gravity), do: mass * gravity * 0.042 - 33

  #  @doc """
  #  equation for calculating the fuel needed for launch
  #
  #  ## Examples
  #
  #    iex> CommandAndService.calculation(:land, 28801, 9.807)
  #    9278.896431000001
  #
  #  """
  @spec calculation(atom(), integer(), float()) :: float
  defp calculation(:land, mass, gravity), do: mass * gravity * 0.033 - 42

  #  @doc """
  #  calculate total fuel needed for operation either landing or launching
  #
  #  ## Examples
  #
  #    iex> calculate_fuel_for_single_route(:land, 28801, 9.807)
  #    13447
  #
  #  """

  @spec calculate_fuel_for_single_route(atom(), integer(), float(), integer()) :: integer
  defp calculate_fuel_for_single_route(operation, mass, gravity, total_fuel \\ 0) do
    fuel =
      operation
      |> calculation(mass, gravity)
      |> round_down()

    if fuel <= 0 , do: total_fuel, else: calculate_fuel_for_single_route(operation, fuel, gravity, fuel + total_fuel)
  end

  @doc """
  calculate total fuel needed for operation either landing or launching

  ## Examples

    iex> CommandAndService.calculate_fuel_for_path(28801, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}])
    51898

  """
  @spec calculate_fuel_for_path(String.t(), String.t()) :: integer
  def calculate_fuel_for_path(mass, commands) when is_binary(mass) and is_binary(commands) do
    {mass, _} =
      mass
      |> Integer.parse()

    calculate_fuel_for_path(mass, sanatize(commands))
  end

  @doc """
  calculate total fuel needed for operation either landing or launching

  ## Examples

    iex> CommandAndService.calculate_fuel_for_path(28801, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}])
    51898

  """
  @spec calculate_fuel_for_path(integer, list(operation_gravity())) :: integer
  def calculate_fuel_for_path(mass, commands) do
    commands
    |> Enum.reverse()
    |> calculate_fuel_for_path(mass, 0)
  end

  @spec calculate_fuel_for_path(list(operation_gravity()), integer , integer) :: integer
  defp calculate_fuel_for_path([], _mass, total_fuel), do: total_fuel

  @spec calculate_fuel_for_path(list(operation_gravity()), integer , integer) :: integer
  defp calculate_fuel_for_path([{operation, gravity} | tail] = _commands , mass, total_fuel) do
    fuel = calculate_fuel_for_single_route(operation, total_fuel + mass, gravity)
    total_fuel = total_fuel + fuel
    calculate_fuel_for_path(tail, mass , total_fuel)
  end
end
