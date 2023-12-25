defmodule Pokemon do
  @enforce_keys [
    :id,
    :name,
    :hp,
    :attack,
    :defense,
    :special_attack,
    :special_defense,
    :speed,
    :weight,
    :height,
    :types
  ]
  defstruct @enforce_keys
end

defmodule Pokelixir do
  @moduledoc """
  Documentation for `Pokelixir`.
  """

  def from_map(map) do
    stats = Map.new(map["stats"], fn stat -> {stat["stat"]["name"], stat["base_stat"]} end)

    %Pokemon{
      id: map["id"],
      name: map["name"],
      hp: stats["hp"],
      attack: stats["attack"],
      defense: stats["defense"],
      special_attack: stats["special-attack"],
      special_defense: stats["special-defense"],
      speed: stats["speed"],
      weight: map["weight"],
      height: map["height"],
      types: Enum.map(map["types"], fn type -> type["type"]["name"] end)
    }
  end

  @spec get(any()) :: struct()
  def get(name) do
    request = Finch.build(:get, "https://pokeapi.co/api/v2/pokemon/#{name}")
    response = Finch.request!(request, MyFinch)
    Jason.decode!(response.body) |> from_map
  end

  @spec all() :: list()
  def all() do
    list_res =
      Finch.build(:get, "https://pokeapi.co/api/v2/pokemon?limit=10") |> Finch.request!(MyFinch)

    results = Jason.decode!(list_res.body)["results"]

    tasks =
      Enum.map(results, fn result ->
        Task.async(fn ->
          res = Finch.build(:get, result["url"]) |> Finch.request!(MyFinch)
          Jason.decode!(res.body) |> from_map
        end)
      end)

    Task.await_many(tasks)
  end
end
