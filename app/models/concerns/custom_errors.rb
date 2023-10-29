module CustomErrors
  class NotSufficientCreditsError < StandardError; end
  class ContractAlreadyCompletedError < StandardError; end
end
