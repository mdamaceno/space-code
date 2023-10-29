class TravelsController < ApplicationController
  def create
    pilot = Pilot.find(travel_params[:pilot_id])
    planet = Planet.find(travel_params[:planet_id])
    pilot.travel_to!(planet)
  end

  private

  def travel_params
    params.require(:travel).permit(:pilot_id, :planet_id)
  end
end
