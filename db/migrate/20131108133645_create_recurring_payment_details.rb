class CreateRecurringPaymentDetails < ActiveRecord::Migration
  def change
    create_table :recurring_payment_details do |t|
      t.string :reference
      t.string :holder_name
      t.string :last_four_digits
      t.date :expires_on
      t.string :variant

      t.timestamps
    end
  end
end
