describe Pbl::Base::Response do
  before(:each) do
    stub_request(:any, "http://0.0.0.0:3001/users/222").to_return(:status => [500, "Internal Server Error"])
  end

  it 'raise a InternalServerErrorException' do

    expect{Pbl::Models::Users::User.find('222')}.to raise_error(Pbl::Exceptions::InternalServerErrorException)

  end

end