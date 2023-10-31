class ReportsController < ApplicationController
  def total_weight_by_each_planet
    render json: Report.new.total_weight_by_each_planet
  end

  def percentage_resource_by_each_pilot
    render json: Report.new.percentage_resource_by_each_pilot
  end

  def transaction_ledger
    render json: Report.new.transaction_ledger
  end
end
