describe PblServiceClient::Services::Users::ValidatePassword  do

  let(:service) { described_class }

  before(:each) do
    params = {email: 'gxbsst@gmail.com', :password => 'secret', first_name: 'first_name' }
    @create_user = user_object.create(params)
  end

  it { expect(service.call("gxbsst@gmail.com", 'secret').email).to eq('gxbsst@gmail.com')}
  subject(:user_object) { PblServiceClient::Models::Users::User }

end