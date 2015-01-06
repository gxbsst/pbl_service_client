def create_object(clazz, options = {})
  default_params.merge(options)
  clazz.create(params)
end

describe Pbl::Models::Assignments::Work do

  shared_examples 'collect clazz_instance' do
    it { expect(clazz_instance.sender_id).to eq('sender_id') }
    it { expect(clazz_instance.content).to eq('content') }
  end

  subject(:clazz) { described_class }
  let(:default_params) {
    {
        object: {
            sender_id: 'sender_id',
            content: 'content',
        }
    }
  }

  describe '.create' do
    context 'successful' do
      let(:params) { {} }
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/assignment/works').to_return(
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
        stub_request(:post, 'http://0.0.0.0:3001/assignment/works').to_return(
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
      let(:update_params) { {level_1: 'level' }}
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/assignment/works/1').to_return(
            body: nil,
            status: 200
        )
      end
      subject(:clazz_instance) { clazz.update('1', update_params)}

      it { expect(clazz_instance.body).to  eq('')}
    end

    context 'failed' do
      let(:update_params) { {level_1: 'update level' }}
      let(:return_body) {
        body =  {error: {name: ['name error']}}
        JSON.generate(body)
      }
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/assignment/works/1').to_return(
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
      stub_request(:delete, 'http://0.0.0.0:3001/assignment/works/1').to_return(
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
      stub_request(:get, 'http://0.0.0.0:3001/assignment/works/1').to_return(
          body: clazz.new(default_params[:object]).to_json,
          status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/assignment/works/2').to_return(
          body: nil,
          status: 404
      )
    end

    context 'project exist' do
      subject(:clazz_instance) { clazz.find!(1)}

      it 'find' do
        expect(clazz_instance.success?).to be_truthy
        expect(clazz_instance.code).to  eq(200)
        expect(clazz_instance.content).to eq('content')
        expect(clazz_instance.sender_id).to eq('sender_id')
      end
    end

    context 'project do not exist' do
      it { expect{clazz.find!(2)}.to raise_error(Pbl::Exceptions::NotFoundException)}
    end

  end
  describe '.find' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/assignment/works/1').to_return(
          body: clazz.new(default_params[:object]).to_json,
          status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/assignment/works/2').to_return(
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
  describe '.where' do
    before(:each) do
      clazz_instances = []
      clazz_instances << clazz.new(default_params[:object])

      stub_request(:get, 'http://0.0.0.0:3001/assignment/works/').to_return(
          body: {'data' => clazz_instances, 'meta' => {total_count: 1, total_pages: 1, per_page: 1, current_page: 1}}.to_json,
          status: 200
      )
    end
    let(:clazz_instances) { clazz.all }

    it { expect(clazz_instances).to be_a Hash}
    it { expect(clazz_instances.fetch(:data).first.content).to eq('content') }
    it { expect(clazz_instances.fetch(:meta)[:total_count]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:total_pages]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:per_page]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:current_page]).to eq(1) }
  end
end