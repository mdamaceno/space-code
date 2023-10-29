module CustomErrors
  class NotSufficientCreditsError < StandardError; end
  class ContractAlreadyCompletedError < StandardError; end
  class ContractWithoutShipError < StandardError; end
  class NoFuelError < StandardError; end
  class RouteBlockedError < StandardError; end
  class NoCargoCapacityError < StandardError; end
end
