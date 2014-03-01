module ParsedResponseHelper
  def parsed_response
    response = respond_to?(:last_response) ? self.last_response : self.response

    ActiveSupport::JSON.decode(response.body)
  end
end

RSpec.configure do |config|
  config.include ParsedResponseHelper, type: :request
  config.include ParsedResponseHelper, type: :controller
end
