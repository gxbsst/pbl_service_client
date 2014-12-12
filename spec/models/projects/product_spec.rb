def create_product(product_object, options = {})
  default_params.merge(options)
  product_object.create(params)
end

describe Pbl::Models::Projects::Product do

  shared_examples 'collect product' do
    it { expect(product.form).to eq('form') }
    it { expect(product.description).to eq('description') }
    it { expect(product.is_final).to eq(false) }
    it { expect(product.project_id).to eq('project_id') }
  end

  subject(:product_object) { described_class }
  let(:default_params) {
    {
      product: {
        form: 'form',
        description: 'description',
        is_final: false,
        project_id: 'project_id'
      }
    }
  }

  describe '.create' do
    context 'successful' do
      let(:params) { {} }
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/pbl/products').to_return(
          body: product_object.new(default_params[:product]).to_json,
          status: 201
        )
      end
      subject!(:product) { create_product(product_object, params) }

      it { expect(product.code).to eq(201) }
      it_behaves_like 'collect product'
    end

    context 'failed' do
      let(:return_body) {
        body = {error: {name: ['name error']}}
        JSON.generate(body)
      }
      let(:params) { {} }
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/pbl/products').to_return(
          body: return_body,
          status: 422,
          headers: {'Header' => 'header'}
        )
      end
      subject!(:product) { create_product(product_object, params) }

      it { expect(product.code).to eq(422) }
      it { expect(product.body).to eq(return_body) }
      it { expect(product.headers).to eq({'Header' => 'header'}) }
    end

  end

  describe '.update' do
    context 'successful' do
      let(:update_params) { {name: 'update_name'} }
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/pbl/products/1').to_return(
          body: nil,
          status: 200
        )
      end
      subject(:update_product) { product_object.update('1', update_params) }

      it { expect(update_product.body).to eq('') }
    end

    context 'failed' do
      let(:update_params) { {name: 'update_name'} }
      let(:return_body) {
        body = {error: {name: ['name error']}}
        JSON.generate(body)
      }
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/pbl/products/1').to_return(
          body: return_body,
          status: 422
        )
      end
      subject(:update_product) { product_object.update('1', update_params) }

      it { expect(update_product.code).to eq(422) }
      it { expect(update_product.body).to eq(return_body) }
    end
  end

  describe '.destroy' do
    before(:each) do
      stub_request(:delete, 'http://0.0.0.0:3001/pbl/products/1').to_return(
        body: nil,
        status: 200
      )
    end
    subject(:result) { product_object.destroy(1) }

    it { expect(result.code).to eq(200) }
    it { expect(result.body).to eq('') }
  end

  describe '.find!' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/pbl/products/1').to_return(
        body: product_object.new(default_params[:product]).to_json,
        status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/pbl/products/2').to_return(
        body: nil,
        status: 404
      )
    end

    context 'product exist' do
      subject(:product) { product_object.find!(1) }

      it 'find' do
        expect(product.success?).to be_truthy
        expect(product.code).to eq(200)
        expect(product.form).to eq('form')
        expect(product.description).to eq('description')
        expect(product.is_final).to eq(false)
        expect(product.project_id).to eq('project_id')
      end
    end

    context 'product do not exist' do
      it { expect { product_object.find!(2) }.to raise_error(Pbl::Exceptions::NotFoundException) }
    end

  end
  describe '.find' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/pbl/products/1').to_return(
        body: product_object.new(default_params[:product]).to_json,
        status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/pbl/products/2').to_return(
        body: '{}',
        status: 404,
        headers: {}
      )
    end

    context 'product is exist' do
      let(:product) { product_object.find(1) }

      it 'find a product' do
        expect(product).to be_truthy
        expect(product.code).to eq(200)
        expect(product.form).to eq('form')
        expect(product.description).to eq('description')
        expect(product.is_final).to eq(false)
        expect(product.project_id).to eq('project_id')
      end
    end

    context 'product is not exist' do
      subject(:product) { product_object.find('2') }

      it { expect(product.code).to eq(404) }
      it { expect(product.headers).to be_a Hash }
      it { expect(product.body).to eq('{}') }
      it { expect(product.success?).to be_falsey }
    end
  end

  describe '.where' do
    before(:each) do
      clazz_instances = []
      clazz_instances << product_object.new(default_params[:product])

      stub_request(:get, 'http://0.0.0.0:3001/pbl/products/').to_return(
        body: {'data' => clazz_instances, 'meta' => {total_count: 1, total_pages: 1, per_page: 1, current_page: 1}}.to_json,
        status: 200
      )
    end
    let(:clazz_instances) { product_object.all }

    it { expect(clazz_instances).to be_a Hash }
    it { expect(clazz_instances.fetch(:data).first.form).to eq('form') }
    it { expect(clazz_instances.fetch(:data).first.description).to eq('description') }
    it { expect(clazz_instances.fetch(:meta)[:total_count]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:total_pages]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:per_page]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:current_page]).to eq(1) }
  end
end