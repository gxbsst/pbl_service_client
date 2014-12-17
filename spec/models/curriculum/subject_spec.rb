
describe Pbl::Models::Curriculum::Subject do

  subject(:subject_object) { described_class }
  let(:default_params) {
    {
        subject: {
            name: 'name',
            position: 1,
            phases: [
                {
                    title: 'title1',
                    position: 1
                }
            ]
        }
    }
  }

  describe '.find' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/curriculum/subjects/1').to_return(
          body: subject_object.new(default_params[:subject]).to_json,
          status: 200
      )
    end

    context 'subject is exist' do
      let(:subject) { subject_object.find(1) }

      it 'find a subject' do
        expect(subject).to be_truthy
        expect(subject.code).to  eq(200)
        expect(subject.name).to eq('name')
        expect(subject.position).to eq(1)
      end
    end

  end

  describe '.find with include' do
    before(:each) do
      stub_request(:get, 'http://0.0.0.0:3001/curriculum/subjects/1?include=phases').to_return(
          body: subject_object.new(default_params[:subject]).to_json,
          status: 200
      )
    end

    context 'subject is exist' do
      let(:subject) { subject_object.find(1, include: 'phases') }

      it 'find a subject' do
        expect(subject).to be_truthy
        expect(subject.code).to  eq(200)
        expect(subject.name).to eq('name')
        expect(subject.position).to eq(1)
        # expect(subject.phases[0].position).to eq(1)
      end
    end

  end

end