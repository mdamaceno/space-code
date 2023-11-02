class ContractsController < ApplicationController
  def index
    contracts = Contract.incomplete.includes(:payload)
    data = { contracts: contracts.as_json(include: :payload) }
    render json: data, status: :ok
  end

  def create
    contract = Contract.new(
      contract_params.except(:payload)
        .merge(payload: contract_params[:payload].map { |p| Resource.new(p) })
    )

    if contract.valid? && contract.has_payload? && contract.payload.all?(&:valid?) && contract.save
      data = { contract: contract.as_json.merge(payload: contract.payload.as_json) }
      render json: data, status: :created
    else
      contract.errors.add(:base, :invalid, message: "Invalid payload") unless contract.has_payload?

      contract_errors = contract.errors.messages
      payload_errors = contract.payload.map(&:errors).map(&:messages).reject(&:empty?).first
      messages = contract_errors.merge(payload_errors || {})

      render json: messages, status: :unprocessable_entity
    end
  end

  def accept
    contract = Contract.find(params[:id])
    pilot = Pilot.find(accept_params[:pilot_id])
    pilot.accept_contract!(contract)
  end

  private

  def contract_params
    params.require(:contract)
      .permit(:description,
              :origin_planet_id,
              :destination_planet_id,
              :value,
              payload: [[ :name, :weight ]])
  end

  def accept_params
    params.require(:contract).permit(:pilot_id)
  end
end
