Adyen::Configuration.class_eval do
  def engine
    Adyen.config
  end
end

