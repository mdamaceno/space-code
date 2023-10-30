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
end
