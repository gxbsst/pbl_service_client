describe Pbl::Services::Users::ValidatePassword  do

  let(:service) { described_class }
  let(:user_object) { Pbl::Models::Users::User }

  let(:default_params) {
    {
      user: {
        username: 'username',
        email: 'gxbsst@gmail.com',
        password: 'secret',
        first_name: 'first_name',
        last_name: 'last_name',
        age: 20,
        gender: 1
      }
    }
  }

  context 'with valid password ' do
    before(:each) do
      stub_request(:post, "http://0.0.0.0:3001/users/#{default_params[:user][:email]}/actions/authenticate").to_return(
        body: user_object.new(default_params[:user]).to_json,
        status: 200
      )
    end
    subject(:user) { service.call(default_params[:user][:email], 'secret') }

    it { expect(user.email).to eq(default_params[:user][:email])}
    it { expect(user.code).to eq(200) }
  end

  context 'with invalid password' do
    before(:each) do
      stub_request(:post, "http://0.0.0.0:3001/users/#{default_params[:user][:email]}/actions/authenticate").to_return(
        body: user_object.new(default_params[:user]).to_json,
        status: 404
      )
    end
    subject(:user) { service.call(default_params[:user][:email], 'error') }

    it { expect(user.code).to eq(404)}
    it { expect(user.headers).to eq(nil) }
  end

end