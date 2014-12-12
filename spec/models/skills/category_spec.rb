def create_object(clazz, options = {})
  default_params.merge(options)
  clazz.create(params)
end

describe Pbl::Models::Skills::Category do

  shared_examples 'collect clazz_instance' do
    it { expect(clazz_instance.name).to eq('name') }
    it { expect(clazz_instance.position).to eq(1) }
  end

  subject(:clazz) { described_class }
  let(:default_params) {
    {
      object: {
        name: 'name',
        position: 1
      }
    }
  }

  describe '.create' do
    context 'successful' do
      let(:params) { {} }
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/skill/categories').to_return(
          body: clazz.new(default_params[:object]).to_json,
          status: 201
        )
      end
      subject!(:clazz_instance) { create_object(clazz, params)}

      it { expect(clazz_instance.code).to eq(201) }
      it_behaves_like 'collect clazz_instance'
    end

    context 'failed' do
      let(:return_body) {
        body =  {error: {name: ['name error']}}
        JSON.generate(body)
      }
      let(:params) { {} }
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/skill/categories').to_return(
          body: return_body,
          status: 422,
          headers: {'Header' => 'header'}
        )
      end
      subject!(:clazz_instance) { create_object(clazz, params)}

      it { expect(clazz_instance.code).to eq(422)}
      it { expect(clazz_instance.body).to eq(return_body)}
      it { expect(clazz_instance.headers).to eq({'Header' => 'header'})}
    end

  end

  describe '.update' do
    context 'successful' do
      let(:update_params) { {name: 'update_name' }}
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/skill/categories/1').to_return(
          body: nil,
          status: 200
        )
      end
      subject(:clazz_instance) { clazz.update('1', update_params)}

      it { expect(clazz_instance.body).to  eq('')}
    end

    context 'failed' do
      let(:update_params) { {name: 'update_name' }}
      let(:return_body) {
        body =  {error: {name: ['name error']}}
        JSON.generate(body)
      }
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/skill/categories/1').to_return(
          body: return_body,
          status: 422
        )
      end
      subject(:clazz_instance) { clazz.update('1', update_params)}
      it { expect(clazz_instance.code).to eq(422) }
      it { expect(clazz_instance.body).to  eq(return_body)}
    end
  end

  describe '.destroy' do
    before(:each) do
      stub_request(:delete, 'http://0.0.0.0:3001/skill/categories/1').to_return(
        body: nil,
        status: 200
      )
    end
    subject(:clazz_instance) { clazz.destroy(1)}

    it { expect(clazz_instance.code).to eq(200)}
    it { expect(clazz_instance.body).to eq('')}
  end

  describe '.find!' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/skill/categories/1').to_return(
        body: clazz.new(default_params[:object]).to_json,
        status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/skill/categories/2').to_return(
        body: nil,
        status: 404
      )
    end

    context 'project exist' do
      subject(:clazz_instance) { clazz.find!(1)}

      it 'find' do
        expect(clazz_instance.success?).to be_truthy
        expect(clazz_instance.code).to  eq(200)
        expect(clazz_instance.name).to eq('name')
        expect(clazz_instance.position).to eq(1)
      end
    end

    context 'project do not exist' do
      it { expect{clazz.find!(2)}.to raise_error(Pbl::Exceptions::NotFoundException)}
    end

  end
  describe '.find' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/skill/categories/1').to_return(
        body: clazz.new(default_params[:object]).to_json,
        status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/skill/categories/2').to_return(
        body: '{}',
        status: 404,
        headers: {}
      )
    end

    context 'project is exist' do
      let(:clazz_instance) { clazz.find(1) }

      it 'find a project' do
        expect(clazz_instance).to be_truthy
        expect(clazz_instance.code).to  eq(200)
        expect(clazz_instance.name).to eq('name')
      end
    end

    context 'project is not exist' do
      subject(:clazz_instance) { clazz.find('2')}

      it { expect(clazz_instance.code).to eq(404) }
      it { expect(clazz_instance.headers).to be_a Hash}
      it { expect(clazz_instance.body).to eq('{}') }
      it { expect(clazz_instance.success?).to be_falsey }
    end
  end
end