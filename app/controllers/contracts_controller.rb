class ContractsController < ApplicationController
  def create
    contract = Contract.new(
      contract_params.except(:payload)
        .merge(payload: contract_params[:payload].map { |p| Resource.new(p) })
    )

    if contract.valid? && contract.payload.all?(&:valid?) && contract.save
      data = { contract: contract.as_json.merge(payload: contract.payload.as_json) }
      render json: data, status: :created
    else
      messages = { contract: contract.errors.messages.merge({ payload: contract.payload.map(&:errors) }) }
      render json: messages, status: :unprocessable_entity
    end
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
end
