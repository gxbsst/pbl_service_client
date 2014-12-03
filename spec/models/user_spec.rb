
def create_user(user_object, options = {})
  default_params.merge(options)
  user_object.create(params)
end

describe Pbl::Models::Users::User do

  shared_examples 'collect user' do
    it { expect(user.first_name).to eq('first_name') }
    it { expect(user.last_name).to eq('last_name') }
    it { expect(user.age).to eq(20) }
    it { expect(user.gender).to eq(1) }
  end

  subject(:user_object) { described_class }

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

  describe '#valid' do
    it 'be valid with a first_name, last_name, age, gender' do
      user = user_object.new(first_name: 'first_name', last_name: 'last_name', age: 20, gender: 1)
      expect(user).to be_valid
    end

    it 'invalid without first_name' do
      user = user_object.new(last_name: 'last_name')
      expect(user).to_not be_valid
    end

    it 'invalid without last_name' do
      user = user_object.new(first_name: 'first_name')
      expect(user).to_not be_valid
    end
  end

  describe 'attributes' do
    let(:user) { user_object.new(first_name: 'first_name', last_name: 'last_name', age: 20, gender: 1, something: 'something', ok: 'ok') }

    it { expect(user.something).to eq('something') }

    it_behaves_like 'collect user'
  end

  describe '.create' do
    context 'successful' do
      let(:params) { {first_name: 'first_name', last_name: 'last_name', age: 20, gender: 1 }}
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/users').to_return(
          body: user_object.new(default_params[:user]).to_json,
          status: 201
        )
      end
      subject!(:user) { create_user(user_object, params)}

      it { expect(user.code).to eq(201) }
      it_behaves_like 'collect user'
    end

    context 'failed' do
      let(:return_body) {
        body =  {error: {firstname: ['first name error']}}
        JSON.generate(body)
      }
      let(:params) { {first_name: 'first_name', last_name: 'last_name', age: 20, gender: 1 }}
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/users').to_return(
          body: return_body,
          status: 422,
          headers: {'Header' => 'header'}
        )
      end
      subject!(:user) { create_user(user_object, params)}

      it { expect(user.code).to eq(422)}
      it { expect(user.body).to eq(return_body)}
      it { expect(user.headers).to eq({'Header' => 'header'})}
    end

  end

  describe '.update' do
    context 'successful' do
      let(:update_params) { {first_name: 'update_first_name', last_name: 'update_last_name', age: 21, gender: 0 }}
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/users/1').to_return(
          body: nil,
          status: 200
        )
      end
      subject(:update_user) { user_object.update('1', update_params)}

      # it { expect(update_user.first_name).to eq('update_first_name') }
      # it { expect(update_user.last_name).to eq('update_last_name') }
      # it { expect(update_user.age).to eq(21) }
      # it { expect(update_user.gender).to eq(0) }
      # it { expect(update_user.code).to eq(200) }
      it { expect(update_user.body).to  eq('')}
    end

    context 'failed' do
      let(:update_params) { {first_name: 'update_first_name', last_name: 'update_last_name', age: 21, gender: 0 }}
      let(:return_body) {
        body =  {error: {firstname: ['first name error']}}
        JSON.generate(body)
      }
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/users/1').to_return(
          body: return_body,
          status: 422
        )
      end
      subject(:update_user) { user_object.update('1', update_params)}

      # it { expect(update_user.first_name).to eq('update_first_name') }
      # it { expect(update_user.last_name).to eq('update_last_name') }
      # it { expect(update_user.age).to eq(21) }
      # it { expect(update_user.gender).to eq(0) }
      it { expect(update_user.code).to eq(422) }
      it { expect(update_user.body).to  eq(return_body)}
    end
  end

  describe '.destroy' do
    before(:each) do
      stub_request(:delete, 'http://0.0.0.0:3001/users/1').to_return(
        body: nil,
        status: 200
      )
    end
    subject(:result) { user_object.destroy(1)}

    it { expect(result.code).to eq(200)}
    it { expect(result.body).to eq('')}
  end

  describe '.find!' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/users/1').to_return(
        body: user_object.new(default_params[:user]).to_json,
        status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/users/2').to_return(
        body: nil,
        status: 404
      )
    end

    context 'user exist' do
      subject(:user) { user_object.find!(1)}

      it 'find' do
        expect(user.success?).to be_truthy
        expect(user.code).to  eq(200)
        expect(user.first_name).to eq('first_name')
        expect(user.last_name).to eq('last_name')
        expect(user.age).to eq(20)
        expect(user.gender).to eq(1)
      end
    end

    context 'user do not exist' do
      it { expect{user_object.find!(2)}.to raise_error(Pbl::Exceptions::NotFoundException)}
    end

  end
  describe '.find' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/users/1').to_return(
        body: user_object.new(default_params[:user]).to_json,
        status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/users/2').to_return(
        body: '{}',
        status: 404,
        headers: {}
      )
    end

    context 'user is exist' do
      let(:user) { user_object.find(1) }

      it { expect(user.success?).to be_truthy }
      it { expect(user.code).to  eq(200)}
      it { expect(user.first_name).to eq('first_name') }
      it { expect(user.last_name).to eq('last_name') }
      it { expect(user.age).to eq(20) }
      it { expect(user.gender).to eq(1) }
    end

    context 'user is not exist' do
      subject(:user) { user_object.find('2')}

      it { expect(user.code).to eq(404) }
      it { expect(user.headers).to be_a Hash}
      it { expect(user.body).to eq('{}') }
      it { expect(user.success?).to be_falsey }
    end
  end

  describe '.where' do
    before(:each) do
      users = []
      users << user_object.new(default_params[:user])

      stub_request(:get, 'http://0.0.0.0:3001/users/?email=gxbsst@gmail.com').to_return(
        # body: user_object.new(default_params[:user]).to_json,
        body: users.to_json,
        status: 200
      )
    end
    let(:users) { user_object.where({email:'gxbsst@gmail.com'})}

    it { expect(users).to be_a Array }
    it { expect(users.first.first_name).to eq('first_name') }
    it { expect(users.first.last_name).to eq('last_name') }
    it { expect(users.first.age).to eq(20) }
    it { expect(users.first.gender).to eq(1) }
  end

end