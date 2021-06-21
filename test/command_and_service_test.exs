defmodule CommandAndServiceTest do
  use ExUnit.Case
  doctest CommandAndService

  test "assert launching from earth to the moon and landing again on earth" do
    assert CommandAndService.calculate_fuel_for_path(28801, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}]) == 51898
  end

  test "assert launching from earth to mars and landing again on earth" do
    assert CommandAndService.calculate_fuel_for_path(14606, [{:launch, 9.807}, {:land, 3.711}, {:launch, 3.711}, {:land, 9.807}]) == 33388
  end

  test "assert launching from earth to the moon and then mars and landing again on earth" do
    assert CommandAndService.calculate_fuel_for_path(75432, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 3.711}, {:launch, 3.711}, {:land, 9.807}]) == 212161
  end
end
