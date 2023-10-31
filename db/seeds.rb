planets = [
  Planet.find_or_create_by(name: "Andvari", id: "bd664ba6-7791-11ee-8601-a8a1599ad2d2"),
  Planet.find_or_create_by(name: "Demeter", id: "c94ff5f2-7791-11ee-b4ad-a8a1599ad2d2"),
  Planet.find_or_create_by(name: "Aqua", id: "d0107542-7791-11ee-862c-a8a1599ad2d2"),
  Planet.find_or_create_by(name: "Calas", id: "d7430cc6-7791-11ee-a929-a8a1599ad2d2"),
]

Route.find_or_create_by(origin_planet_id: planets[0].id, destination_planet_id: planets[1].id, blocked: true)
Route.find_or_create_by(origin_planet_id: planets[0].id, destination_planet_id: planets[2].id, fuel_cost: 13)
Route.find_or_create_by(origin_planet_id: planets[0].id, destination_planet_id: planets[3].id, fuel_cost: 23)

Route.find_or_create_by(origin_planet_id: planets[1].id, destination_planet_id: planets[0].id, blocked: true)
Route.find_or_create_by(origin_planet_id: planets[1].id, destination_planet_id: planets[2].id, fuel_cost: 22)
Route.find_or_create_by(origin_planet_id: planets[1].id, destination_planet_id: planets[3].id, fuel_cost: 25)

Route.find_or_create_by(origin_planet_id: planets[2].id, destination_planet_id: planets[0].id, blocked: true)
Route.find_or_create_by(origin_planet_id: planets[2].id, destination_planet_id: planets[1].id, fuel_cost: 30)
Route.find_or_create_by(origin_planet_id: planets[2].id, destination_planet_id: planets[3].id, fuel_cost: 12)

Route.find_or_create_by(origin_planet_id: planets[3].id, destination_planet_id: planets[0].id, fuel_cost: 20)
Route.find_or_create_by(origin_planet_id: planets[3].id, destination_planet_id: planets[1].id, fuel_cost: 25)
Route.find_or_create_by(origin_planet_id: planets[3].id, destination_planet_id: planets[2].id, fuel_cost: 15)
