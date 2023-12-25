defmodule PokelixirTest do
  use ExUnit.Case
  @doctest Pokelixir

  test "get pokemon by name" do
    assert Pokelixir.get("charizard") == %Pokemon{
             id: 6,
             name: "charizard",
             hp: 78,
             attack: 84,
             defense: 78,
             special_attack: 109,
             special_defense: 85,
             speed: 100,
             weight: 905,
             height: 17,
             types: ["fire", "flying"]
           }
  end

  test "get all pokemons" do
    assert Pokelixir.all() |> length() > 0
  end
end
