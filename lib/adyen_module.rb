module Adyen
  def self.setup(&block)
    @config ||= AdyenEngine::ConfigContainer.new
    @config.configure_with &block
  end

  def self.config
    @config ||= AdyenEngine::ConfigContainer.new
  end
end
