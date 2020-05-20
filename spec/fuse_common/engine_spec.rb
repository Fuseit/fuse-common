RSpec.describe FuseCommon::Engine do
  before do
    # reload entire app to test engine initialisation setup
    Object.send(:remove_const, :FuseCommon) if Module.const_defined?(:FuseCommon)
    fuse_common_files = $LOADED_FEATURES.grep(/fuse_common/)
    fuse_common_files.each do |file|
      load file
    end
  end

  context 'when airbrake is configured' do
    let(:airbrake_project_id) { 'AIRBRAKE_PROJECT_ID' }
    let(:airbrake_project_key) { 'AIRBRAKE_PROJECT_KEY' }
    let(:airbrake_environment_name) { 'Rails.env' }

    before do
      FuseCommon.configure do |c|
        c.airbrake_project_id = airbrake_project_id
        c.airbrake_project_key = airbrake_project_key
        c.airbrake_environment_name = airbrake_environment_name
      end
    end

    it 'sets the configuration' do
      expect(FuseCommon.configuration).to be_a(FuseCommon::Configuration)
    end

    it 'set the airbrake_project_id' do
      expect(FuseCommon.configuration.airbrake_project_id).to eq(airbrake_project_id)
    end

    it 'set the airbrake_project_key' do
      expect(FuseCommon.configuration.airbrake_project_key).to eq(airbrake_project_key)
    end

    it 'set the airbrake_environment_name' do
      expect(FuseCommon.configuration.airbrake_environment_name).to eq(airbrake_environment_name)
    end

    it 'set the airbrake_config_provided? to true' do
      expect(FuseCommon.airbrake_config_provided?).to eq(true)
    end
  end

  context 'when airbrake is not configured' do
    it 'set the airbrake_config_provided? to false' do
      expect(FuseCommon.airbrake_config_provided?).to eq(false)
    end
  end
end
