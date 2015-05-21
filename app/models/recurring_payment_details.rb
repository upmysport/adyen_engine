# An ActiveRecord model representing one payment detail returned by
# Adyen::API.list_recurring_details so that the details can be locally
# cached in the database.
# Currently, this only represents card details, with no inheritance to
# accommodate ELV or bank details.
class RecurringPaymentDetails < ActiveRecord::Base
  validates_presence_of :reference, :expires_on, :last_four_digits

  class << self
    # Maps a Adyen::API::RecurringService::ListResponse to a RecurringPaymentDetails
    # object and saves it to the database.
    def create_from!(response)
      card = response[:card]
      expiry = card[:expiry_date] ? card[:expiry_date].end_of_month : nil
      create! reference: response[:recurring_detail_reference],
              variant: response[:variant],
              expires_on: expiry,
              holder_name: card[:holder_name],
              last_four_digits: card[:number]
    end
  end
end
