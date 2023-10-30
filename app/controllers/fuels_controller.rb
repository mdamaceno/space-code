class FuelsController < ApplicationController
  def create
    pilot = Pilot.find(fuel_params[:pilot_id])
    pilot.buy_fuel(fuel_params[:units].to_i)
  end

  private

  def fuel_params
    params.require(:fuel).permit(:pilot_id, :units)
  end
end
