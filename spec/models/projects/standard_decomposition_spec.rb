def create_standard_decomposition(standard_decomposition_object, options = {})
  default_params.merge(options)
  standard_decomposition_object.create(params)
end

describe Pbl::Models::Projects::StandardDecomposition do

  shared_examples 'collect standard_decomposition' do
    it { expect(standard_decomposition.role).to eq('role') }
    it { expect(standard_decomposition.verb).to eq('verb') }
    it { expect(standard_decomposition.technique).to eq('technique') }
    it { expect(standard_decomposition.noun).to eq('noun') }
    it { expect(standard_decomposition.product_name).to eq('product_name') }
    it { expect(standard_decomposition.product_id).to eq('product_id') }
  end

  subject(:standard_decomposition_object) { described_class }
  let(:default_params) {
    {
      standard_decomposition: {
        role: 'role',
        verb: 'verb',
        technique: 'technique',
        noun: 'noun',
        product_name: 'product_name',
        product_id: 'product_id'
      }
    }
  }

  describe '.create' do
    context 'successful' do
      let(:params) { {} }
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/pbl/standard_decompositions').to_return(
          body: standard_decomposition_object.new(default_params[:standard_decomposition]).to_json,
          status: 201
        )
      end
      subject!(:standard_decomposition) { create_standard_decomposition(standard_decomposition_object, params) }

      it { expect(standard_decomposition.code).to eq(201) }
      it_behaves_like 'collect standard_decomposition'
    end

    context 'failed' do
      let(:return_body) {
        body = {error: {name: ['name error']}}
        JSON.generate(body)
      }
      let(:params) { {} }
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/pbl/standard_decompositions').to_return(
          body: return_body,
          status: 422,
          headers: {'Header' => 'header'}
        )
      end
      subject!(:standard_decomposition) { create_standard_decomposition(standard_decomposition_object, params) }

      it { expect(standard_decomposition.code).to eq(422) }
      it { expect(standard_decomposition.body).to eq(return_body) }
      it { expect(standard_decomposition.headers).to eq({'Header' => 'header'}) }
    end

  end

  describe '.update' do
    context 'successful' do
      let(:update_params) { {name: 'update_name'} }
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/pbl/standard_decompositions/1').to_return(
          body: nil,
          status: 200
        )
      end
      subject(:update_standard_decomposition) { standard_decomposition_object.update('1', update_params) }

      # it { expect(update_standard_decomposition.first_name).to eq('update_first_name') }
      # it { expect(update_standard_decomposition.last_name).to eq('update_last_name') }
      # it { expect(update_standard_decomposition.age).to eq(21) }
      # it { expect(update_standard_decomposition.gender).to eq(0) }
      # it { expect(update_standard_decomposition.code).to eq(200) }
      it { expect(update_standard_decomposition.body).to eq('') }
    end

    context 'failed' do
      let(:update_params) { {name: 'update_name'} }
      let(:return_body) {
        body = {error: {name: ['name error']}}
        JSON.generate(body)
      }
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/pbl/standard_decompositions/1').to_return(
          body: return_body,
          status: 422
        )
      end
      subject(:update_standard_decomposition) { standard_decomposition_object.update('1', update_params) }

      it { expect(update_standard_decomposition.code).to eq(422) }
      it { expect(update_standard_decomposition.body).to eq(return_body) }
    end
  end

  describe '.destroy' do
    before(:each) do
      stub_request(:delete, 'http://0.0.0.0:3001/pbl/standard_decompositions/1').to_return(
        body: nil,
        status: 200
      )
    end
    subject(:result) { standard_decomposition_object.destroy(1) }

    it { expect(result.code).to eq(200) }
    it { expect(result.body).to eq('') }
  end

  describe '.find!' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/pbl/standard_decompositions/1').to_return(
        body: standard_decomposition_object.new(default_params[:standard_decomposition]).to_json,
        status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/pbl/standard_decompositions/2').to_return(
        body: nil,
        status: 404
      )
    end

    context 'standard_decomposition exist' do
      subject(:standard_decomposition) { standard_decomposition_object.find!(1) }

      it 'find' do
        expect(standard_decomposition.success?).to be_truthy
        expect(standard_decomposition.code).to eq(200)
        expect(standard_decomposition.role).to eq('role')
        expect(standard_decomposition.verb).to eq('verb')
        expect(standard_decomposition.technique).to eq('technique')
        expect(standard_decomposition.noun).to eq('noun')
        expect(standard_decomposition.product_name).to eq('product_name')
        expect(standard_decomposition.product_id).to eq('product_id')
      end
    end

    context 'standard_decomposition do not exist' do
      it { expect { standard_decomposition_object.find!(2) }.to raise_error(Pbl::Exceptions::NotFoundException) }
    end

  end
  describe '.find' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/pbl/standard_decompositions/1').to_return(
        body: standard_decomposition_object.new(default_params[:standard_decomposition]).to_json,
        status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/pbl/standard_decompositions/2').to_return(
        body: '{}',
        status: 404,
        headers: {}
      )
    end

    context 'standard_decomposition is exist' do
      let(:standard_decomposition) { standard_decomposition_object.find(1) }

      it 'find a standard_decomposition' do
        expect(standard_decomposition).to be_truthy
        expect(standard_decomposition.code).to eq(200)
        expect(standard_decomposition.role).to eq('role')
        expect(standard_decomposition.verb).to eq('verb')
        expect(standard_decomposition.technique).to eq('technique')
        expect(standard_decomposition.noun).to eq('noun')
        expect(standard_decomposition.product_name).to eq('product_name')
        expect(standard_decomposition.product_id).to eq('product_id')
      end
    end

    context 'standard_decomposition is not exist' do
      subject(:standard_decomposition) { standard_decomposition_object.find('2') }

      it { expect(standard_decomposition.code).to eq(404) }
      it { expect(standard_decomposition.headers).to be_a Hash }
      it { expect(standard_decomposition.body).to eq('{}') }
      it { expect(standard_decomposition.success?).to be_falsey }
    end
  end

  describe '.where' do
    before(:each) do
      clazz_instances = []
      clazz_instances << standard_decomposition_object.new(default_params[:standard_decomposition])

      stub_request(:get, 'http://0.0.0.0:3001/pbl/standard_decompositions/').to_return(
        body: {'data' => clazz_instances, 'meta' => {total_count: 1, total_pages: 1, per_page: 1, current_page: 1}}.to_json,
        status: 200
      )
    end
    let(:clazz_instances) { standard_decomposition_object.all }

    it { expect(clazz_instances).to be_a Hash }
    it { expect(clazz_instances.fetch(:data).first.role).to eq('role') }
    it { expect(clazz_instances.fetch(:data).first.verb).to eq('verb') }
    it { expect(clazz_instances.fetch(:meta)[:total_count]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:total_pages]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:per_page]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:current_page]).to eq(1) }
  end
end