def create_project(project_object, options = {})
  default_params.merge(options)
  project_object.create(params)
end

describe Pbl::Models::Projects::Project do

  shared_examples 'collect project' do
    it { expect(project.name).to eq('name') }
    it { expect(project.description).to eq('description') }
    it { expect(project.driven_issue).to eq('driven_issue') }
    it { expect(project.standard_analysis).to eq('standard_analysis') }
    it { expect(project.rule_head).to eq('rule_head') }
    it { expect(project.rule_template).to eq('rule_template') }
  end

  subject(:project_object) { described_class }
  let(:default_params) {
    {
      project: {
        name: 'name',
        description: 'description',
        driven_issue: 'driven_issue',
        standard_analysis: 'standard_analysis',
        rule_head: 'rule_head',
        rule_template: 'rule_template'
      }
    }
  }

  describe '.create' do
    context 'successful' do
      let(:params) { {} }
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/pbl/projects').to_return(
          body: project_object.new(default_params[:project]).to_json,
          status: 201
        )
      end
      subject!(:project) { create_project(project_object, params)}

      it { expect(project.code).to eq(201) }
      it_behaves_like 'collect project'
    end

    context 'failed' do
      let(:return_body) {
        body =  {error: {name: ['name error']}}
        JSON.generate(body)
      }
      let(:params) { {} }
      before(:each) do
        stub_request(:post, 'http://0.0.0.0:3001/pbl/projects').to_return(
          body: return_body,
          status: 422,
          headers: {'Header' => 'header'}
        )
      end
      subject!(:project) { create_project(project_object, params)}

      it { expect(project.code).to eq(422)}
      it { expect(project.body).to eq(return_body)}
      it { expect(project.headers).to eq({'Header' => 'header'})}
    end

  end

  describe '.update' do
    context 'successful' do
      let(:update_params) { {name: 'update_name' }}
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/pbl/projects/1').to_return(
          body: nil,
          status: 200
        )
      end
      subject(:update_project) { project_object.update('1', update_params)}

      # it { expect(update_project.first_name).to eq('update_first_name') }
      # it { expect(update_project.last_name).to eq('update_last_name') }
      # it { expect(update_project.age).to eq(21) }
      # it { expect(update_project.gender).to eq(0) }
      # it { expect(update_project.code).to eq(200) }
      it { expect(update_project.body).to  eq('')}
    end

    context 'failed' do
      let(:update_params) { {name: 'update_name' }}
      let(:return_body) {
        body =  {error: {name: ['name error']}}
        JSON.generate(body)
      }
      before(:each) do
        stub_request(:patch, 'http://0.0.0.0:3001/pbl/projects/1').to_return(
          body: return_body,
          status: 422
        )
      end
      subject(:update_project) { project_object.update('1', update_params)}

      # it { expect(update_project.first_name).to eq('update_first_name') }
      # it { expect(update_project.last_name).to eq('update_last_name') }
      # it { expect(update_project.age).to eq(21) }
      # it { expect(update_project.gender).to eq(0) }
      it { expect(update_project.code).to eq(422) }
      it { expect(update_project.body).to  eq(return_body)}
    end
  end

  describe '.destroy' do
    before(:each) do
      stub_request(:delete, 'http://0.0.0.0:3001/pbl/projects/1').to_return(
        body: nil,
        status: 200
      )
    end
    subject(:result) { project_object.destroy(1)}

    it { expect(result.code).to eq(200)}
    it { expect(result.body).to eq('')}
  end

  describe '.find!' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/pbl/projects/1').to_return(
        body: project_object.new(default_params[:project]).to_json,
        status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/pbl/projects/2').to_return(
        body: nil,
        status: 404
      )
    end

    context 'project exist' do
      subject(:project) { project_object.find!(1)}

      it 'find' do
        expect(project.success?).to be_truthy
        expect(project.code).to  eq(200)
        expect(project.name).to eq('name')
        expect(project.description).to eq('description')
        expect(project.driven_issue).to eq('driven_issue')
        expect(project.standard_analysis).to eq('standard_analysis')
      end
    end

    context 'project do not exist' do
      it { expect{project_object.find!(2)}.to raise_error(Pbl::Exceptions::NotFoundException)}
    end

  end
  describe '.find' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/pbl/projects/1').to_return(
        body: project_object.new(default_params[:project]).to_json,
        status: 200
      )
      stub_request(:get, 'http://0.0.0.0:3001/pbl/projects/2').to_return(
        body: '{}',
        status: 404,
        headers: {}
      )
    end

    context 'project is exist' do
      let(:project) { project_object.find(1) }

      it 'find a project' do
        expect(project).to be_truthy
        expect(project.code).to  eq(200)
        expect(project.name).to eq('name')
        expect(project.description).to eq('description')
        expect(project.driven_issue).to eq('driven_issue')
        expect(project.standard_analysis).to eq('standard_analysis')
      end
    end

    context 'project is not exist' do
      subject(:project) { project_object.find('2')}

      it { expect(project.code).to eq(404) }
      it { expect(project.headers).to be_a Hash}
      it { expect(project.body).to eq('{}') }
      it { expect(project.success?).to be_falsey }
    end
  end

  describe '.where' do
    before(:each) do
      clazz_instances = []
      clazz_instances << project_object.new(default_params[:project])

      stub_request(:get, 'http://0.0.0.0:3001/pbl/projects/').to_return(
        body: {'data' => clazz_instances, 'meta' => {total_count: 1, total_pages: 1, per_page: 1, current_page: 1}}.to_json,
        status: 200
      )
    end
    let(:clazz_instances) { project_object.all }

    it { expect(clazz_instances).to be_a Hash}
    it { expect(clazz_instances.fetch(:data).first.name).to eq('name') }
    it { expect(clazz_instances.fetch(:data).first.description).to eq('description') }
    it { expect(clazz_instances.fetch(:meta)[:total_count]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:total_pages]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:per_page]).to eq(1) }
    it { expect(clazz_instances.fetch(:meta)[:current_page]).to eq(1) }

    context 'when a empty array' do
      before(:each) do
        stub_request(:get, 'http://0.0.0.0:3001/pbl/projects/').to_return(
          body: {'data' => [], 'meta' => {total_count: 1, total_pages: 1, per_page: 1, current_page: 1}}.to_json,
          status: 200
        )
      end
      let(:clazz_instances) { project_object.all }
      it { expect(clazz_instances.fetch(:data)).to eq([]) }

    end
  end
end