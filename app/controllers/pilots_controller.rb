class PilotsController < ApplicationController
  def create
    pilot = Pilot.new(
      pilot_params.except(:ship)
        .merge(certification: Pilot.generate_valid_certification)
        .merge(ship: Ship.new(pilot_params[:ship]))
    )

    if pilot.valid? && pilot.ship.valid? && pilot.save
      data = { pilot: pilot.as_json.merge(ship: pilot.ship.as_json) }
      render json: data, status: :created
    else
      messages = { pilot: pilot.errors.messages.merge({ ship: pilot.ship.errors.messages }) }
      render json: messages, status: :unprocessable_entity
    end
  end

  private

  def pilot_params
    params.require(:pilot).permit(:name, :age, ship: [:name, :fuel_capacity, :fuel_level, :weight_capacity])
  end
end
