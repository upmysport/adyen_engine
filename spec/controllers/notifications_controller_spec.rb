require File.expand_path('../../spec_helper', __FILE__)

describe Adyen::NotificationsController, '#notify' do

  let(:event_date) {DateTime.now}

  let(:params) {
    {event_code: 'AUTHORISATION',
     psp_reference: generate(:psp_reference),
     live: false,
     original_reference: 'origref',
     merchant_reference: 'booking_ref',
     merchant_account_code: 'upmysport_test',
     event_date: event_date}
  }

  context 'when basic auth is enabled' do
    before do
      Adyen.setup do |config|
        config.disable_basic_auth = false
      end
    end

    context 'when credentials are provided' do
      before do
        Adyen.setup do |config|
          config.http_username = 'changeme'
          config.http_password = 'iamnotsecure'
        end

        request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("#{basic_user}:iamnotsecure")
      end

      context 'when an authorised request is received' do
        let!(:basic_user) {'changeme'}

        before do
          post :notify, params.merge(use_route: :adyen)
        end

        it 'will be successful' do expect(response.response_code).to eq 200 end
        it 'will return the expected content' do expect(response.body).to eq '[accepted]' end
        it 'will create a notification' do expect(assigns[:notification]).to_not be_nil end
        it 'will create a new notification' do expect(assigns[:notification].class).to eq AdyenNotification end
      end

      context 'when the request throws a record invalid error' do
        let!(:basic_user) {'changeme'}

        before do
          post :notify, use_route: :adyen,
               event_code: 'AUTHORISATION',
               live: false,
               original_reference: 'origref',
               merchant_reference: 'booking_ref',
               merchant_account_code: 'upmysport_test',
               event_date: event_date
        end

        it 'will be successful' do expect(response.response_code).to eq 200 end
        it 'will return the expected content' do expect(response.body).to eq '[accepted]' end
      end

      context 'when the request is invalid' do
        let!(:basic_user) {'changeme'}

        before do
          post :notify, use_route: :adyen,
               event_code: 'AUTHORISATION',
               live: false,
               psp_reference: generate(:psp_reference),
               merchant_reference: 'booking_ref'
        end

        it 'will be successful' do expect(response.response_code).to eq 200 end
        it 'will return the expected content' do expect(response.body).to eq '[accepted]' end
      end

      context 'when the adyen notification blows up unexpectedly' do
        class UnstableNotification
          def log(params)
            raise StandardError.new 'Ship\'s going down!'
          end
        end

        let!(:basic_user) {'changeme'}

        before do
          unstable_notification = UnstableNotification.new
          stub_const('AdyenNotification', unstable_notification)
          post :notify, params.merge(use_route: :adyen)
        end

        it 'will be successful' do expect(response.response_code).to eq 200 end
        it 'will return the expected content' do expect(response.body).to eq '[accepted]' end
      end

      context 'when the wrong credentials are provided' do
        let!(:basic_user) {'notcorrect'}

        before do
          post :notify, params.merge(use_route: :adyen)
        end

        it 'will not be authorised' do expect(response.response_code).to eq 401 end
      end
    end

    context 'when no credentials are provided' do
      before do
        post :notify, use_route: :adyen
      end

      it 'will not be authorised' do expect(response.response_code).to eq 401 end
    end
  end

  context 'when basic auth is disabled' do
    before do
      Adyen.setup do |config|
        config.disable_basic_auth = true
      end

      before do
        post :notify, params.merge(use_route: :adyen)
      end

      it 'will be successful' do expect(response.response_code).to eq 200 end
      it 'will return the expected content' do expect(response.body).to eq '[accepted]' end
    end
  end

  context 'when no config block is provided to the engine' do
    it 'will raise the expected error' do expect { Adyen.setup }.to raise_error AdyenEngine::ConfigMissing end
  end

  context 'when no config has been run' do
    before :each do
      Adyen.instance_variable_set(:@config, nil)
    end

    it 'will raise the expected error' do
      expect { post :notify, params.merge(use_route: :adyen) }.to raise_error AdyenEngine::NotConfigured
    end
  end
end