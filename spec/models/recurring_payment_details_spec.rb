require 'spec_helper'

describe RecurringPaymentDetails, '.create_from!' do
  context 'when the details are valid' do
    subject do
      response = {
          recurring_detail_reference: 'aref',
          variant: 'visa',
          card: {expiry_date: Date.new(2017, 4, 1).end_of_month, holder_name: 'test test', number: '4321'}
      }

      RecurringPaymentDetails.create_from! response
    end

    it 'will set the reference' do expect(subject.reference).to eq 'aref' end
    it 'will set the variant' do expect(subject.variant).to eq 'visa' end
    it 'will set the expires on year' do expect(subject.expires_on.year).to eq 2017 end
    it 'will set the expires on month' do expect(subject.expires_on.month).to eq 4 end
    it 'will set the expires on day to the end of the month' do expect(subject.expires_on.day).to eq 30 end
    it 'will set the holder name' do expect(subject.holder_name).to eq 'test test' end
    it 'will set the card number' do expect(subject.last_four_digits).to eq '4321' end
    it 'will be valid' do expect(subject.valid?).to be_true end
  end

  context 'when the payment detail reference is missing' do
    let :response do
      response = {
          variant: 'visa',
          card: {expiry_date: Date.new(2017, 4, 1).end_of_month, holder_name: 'test test', number: '4321'}
      }
    end

    it 'will not be valid' do expect {RecurringPaymentDetails.create_from! response}.to raise_error ActiveRecord::RecordInvalid end
  end

  context 'when the expiry date is missing' do
    let :response do
      response = {
          recurring_detail_reference: 'aref',
          variant: 'visa',
          card: {holder_name: 'test test', number: '4321'}
      }
    end

    it 'will not be valid' do expect {RecurringPaymentDetails.create_from! response}.to raise_error ActiveRecord::RecordInvalid end
  end

  context 'when the number is missing' do
    let :response do
      response = {
          recurring_detail_reference: 'aref',
          variant: 'visa',
          card: {expiry_date: Date.new(2017, 4, 1).end_of_month, holder_name: 'test test'}
      }
    end

    it 'will not be valid' do expect {RecurringPaymentDetails.create_from! response}.to raise_error ActiveRecord::RecordInvalid end
  end
end