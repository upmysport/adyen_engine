require 'rails'

# @private
class AdyenEngine::Railtie < ::Rails::Railtie
  
  generators do
    require 'adyen/notification_generator'
  end
  
  config.before_configuration do
    config.adyen = Adyen.configuration
  end
end
