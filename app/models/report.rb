class Report
  def total_weight_by_each_planet
    Planet.includes(:origin_contracts, :destination_contracts).map do |planet|
      origin_contracts = planet.origin_contracts.completed.includes(:payload)
      origin_resources = origin_contracts.map(&:payload).flatten.pluck(:name, :weight)

      destination_contracts = planet.destination_contracts.completed.includes(:payload)
      destination_resources = destination_contracts.map(&:payload).flatten.pluck(:name, :weight)

      {
        planet.name.downcase => {
          "sent" => {
            "water" => origin_resources.select { |r| r.first == 'water' }.sum(&:second),
            "food" => origin_resources.select { |r| r.first == 'food' }.sum(&:second),
            "minerals" => origin_resources.select { |r| r.first == 'minerals' }.sum(&:second),
          },
          "received" => {
            "water" => destination_resources.select { |r| r.first == 'water' }.sum(&:second),
            "food" => destination_resources.select { |r| r.first == 'food' }.sum(&:second),
            "minerals" => destination_resources.select { |r| r.first == 'minerals' }.sum(&:second),
          },
        },
      }
    end
  end

  def percentage_resource_by_each_pilot
    Pilot.includes(:contracts).map do |pilot|
      contracts = pilot.contracts.completed.includes(:payload)
      resources = contracts.map(&:payload).flatten.pluck(:name, :weight)
      total_resources = resources.sum(&:second)
      percentage_by_resource = resources.group_by(&:first).map do |k, r|
        [k, r.sum(&:second) / total_resources.to_f * 100]
      end.sort

      {
        pilot.name.downcase => {
          "water" => percentage_by_resource.find { |r| r.first == 'water' }&.second || 0,
          "food" => percentage_by_resource.find { |r| r.first == 'food' }&.second || 0,
          "minerals" => percentage_by_resource.find { |r| r.first == 'minerals' }&.second || 0,
        },
      }
    end
  end

  def transaction_ledger
    Transaction.order(created_at: :asc).map(&:description)
  end
end
