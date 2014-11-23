describe PblServiceClient::Services::Users::ValidatePassword  do

  subject(:user_object) { PblServiceClient::Models::Users::User }

  before(:each) do
    params = {email: 'gxbsst@gmail.com', :password => 'secret', first_name: 'first_name' }
    @create_user = user_object.create(params)
  end

  it { expect(user_object.validate_password("gxbsst@gmail.com", 'secret').email).to eq('gxbsst@gmail.com')}

end