planets = [
  Planet.find_or_create_by(name: "Andvari"),
  Planet.find_or_create_by(name: "Demeter"),
  Planet.find_or_create_by(name: "Aqua"),
  Planet.find_or_create_by(name: "Calas"),
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
