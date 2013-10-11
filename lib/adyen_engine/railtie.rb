require 'rails'

# @private
class AdyenEngine::Railtie < ::Rails::Railtie
  config.before_configuration do
    config.adyen = Adyen.configuration
  end
end
