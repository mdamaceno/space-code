class PlanetsController < ApplicationController
  def index
    render json: { planets: Planet.order(:name).all }
  end
end
