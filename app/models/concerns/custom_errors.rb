module CustomErrors
  class NotSufficientCreditsError < StandardError; end
  class ContractAlreadyCompletedError < StandardError; end
  class ContractWithoutShipError < StandardError; end
  class NoFuelError < StandardError; end
  class RouteBlockedError < StandardError; end
  class NoCargoCapacityError < StandardError; end
  class PilotNotInDestinationPlanetError < StandardError; end
  class PilotNotInOriginPlanetError < StandardError; end
end
