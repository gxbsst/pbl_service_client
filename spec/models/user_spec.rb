
# describe PblServiceClient::Models::Users::User do

def create_user(user_object, options = {})
  params = {
    email: Time.now.to_i.to_s + '@e.com',
    password: 'secret',
    first_name: 'first_name',
    last_name: 'last_name',
    age: 20,
    gender: 1
  }.merge(options)

  user_object.create(params)
end

describe PBL::Client::Users::User do

  shared_examples 'collect user' do
    it { expect(user.first_name).to eq('first_name') }
    it { expect(user.last_name).to eq('last_name') }
    it { expect(user.age).to eq(20) }
    it { expect(user.gender).to eq(1) }
  end

  subject(:user_object) { described_class }

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
    let(:user) { user_object.new(first_name: 'first_name', last_name: 'last_name', age: 20, gender: 1) }

    it_behaves_like 'collect user'
  end

  describe '.create' do
    let(:params) { {first_name: 'first_name', last_name: 'last_name', age: 20, gender: 1 }}
    subject!(:user) { create_user(user_object, params)}

    it_behaves_like 'collect user'
  end

  describe '.update' do
    let(:params) { {first_name: 'first_name', last_name: 'last_name', age: 20, gender: 1 }}
    let(:update_params) { {first_name: 'update_first_name', last_name: 'update_last_name', age: 21, gender: 0 }}
    before(:each) do
     @create_user = user_object.create(params)
    end

    subject(:update_user) { user_object.update(@create_user.id.to_s, update_params)}

    it { expect(update_user.first_name).to eq('update_first_name') }
    it { expect(update_user.last_name).to eq('update_last_name') }
    it { expect(update_user.age).to eq(21) }
    it { expect(update_user.gender).to eq(0) }
  end

  describe '.destory' do
    before(:each) do
      @create_user = create_user(user_object)
    end

    subject(:result) { user_object.destroy(@create_user.id.to_s)}

    it { expect(result).to be_truthy}
  end

  describe '.find' do
    before(:each) do
      @create_user = create_user(user_object)
    end

    subject(:user) { user_object.find(@create_user.id.to_s)}
    it_behaves_like 'collect user'
  end

  describe '.where' do
    let(:params) { {first_name: 'first_name', last_name: 'last_name', age: 20, gender: 1 }}
    before(:each) do
      @create_user = user_object.create(params)
    end

    subject(:users) { user_object.where({id: @create_user.id.to_s})}

    it { expect(users).to be_a Array }
    it { expect(users.first.first_name).to eq('first_name') }
    it { expect(users.first.last_name).to eq('last_name') }
    it { expect(users.first.age).to eq(20) }
    it { expect(users.first.gender).to eq(1) }
  end

end