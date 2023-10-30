class ReportsController < ApplicationController
  def total_weight_by_each_planet
    render json: Report.new.total_weight_by_each_planet
  end
end
