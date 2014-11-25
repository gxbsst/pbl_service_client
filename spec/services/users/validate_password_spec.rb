describe PblServiceClient::Services::Users::ValidatePassword  do

  let(:service) { described_class }
  let(:user_object) { PBL::Client::Users::User }

  before(:each) do
    @email = "#{Time.now.to_i}@gmail.com"
    params = {email: @email, :password => 'secret', first_name: 'first_name' }
    @create_user = user_object.create(params)
  end


  context 'with valid password ' do
    subject(:user) { service.call(@email, 'secret') }

    it { expect(user.email).to eq(@email)}
    it { expect(user.code).to eq(200) }
  end

  context 'with invalid password' do
    subject(:user) { service.call(@email, 'error') }
    it { expect(user.code).to eq(404)}
  end

end