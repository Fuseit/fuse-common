RSpec.describe FuseCommon::Configuration do
  describe 'initialization' do
    it 'sets default value for the airbrake_project_id attribute' do
      configuration = described_class.new
      expect(configuration.airbrake_project_id).to eq(nil)
    end

    it 'sets default value for the airbrake_project_key attribute' do
      configuration = described_class.new
      expect(configuration.airbrake_project_key).to eq(nil)
    end

    it 'sets default value for the airbrake_environment_name attribute' do
      configuration = described_class.new
      expect(configuration.airbrake_environment_name).to eq(Rails.env)
    end
  end
end
