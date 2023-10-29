module CustomErrors
  class NotSufficientCreditsError < StandardError; end
  class ContractAlreadyCompletedError < StandardError; end
  class ContractWithoutShipError < StandardError; end
  class NoFuelError < StandardError; end
end
