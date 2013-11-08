class RecurringPaymentDetails < ActiveRecord::Base
  attr_accessible :expires_on, :holder_name, :last_four_digits, :reference, :variant

  class << self
    def create_from!(response)
      card = response[:card]
      expiry = Date.new(card[:expiry_year].to_i, card[:expiry_month].to_i, 1).end_of_month
      create! reference: response[:recurring_detail_reference],
              variant: response[:variant],
              expires_on: expiry
    end
  end
end
