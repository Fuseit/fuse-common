require 'fuse_common/configuration'
require 'rails'
require 'airbrake'

module FuseCommon
  mattr_accessor :configuration

  # Returns the configuration class instance if block given
  #
  # @return [FuseCommon::Configuration]
  def self.configure
    self.configuration ||= ::FuseCommon::Configuration.new

    yield(configuration) if block_given?
  end

  def self.airbrake_config_provided?
    !!(configuration&.airbrake_project_id &&
        configuration&.airbrake_project_key &&
        configuration&.airbrake_environment_name
      )
  end

  class Engine < Rails::Engine
    isolate_namespace FuseCommon

    initializer 'fuse_common.configure_airbrake' do
      require 'fuse_common/airbrake_config'
      if FuseCommon.airbrake_config_provided?
        FuseCommon::AirbrakeConfig.new(FuseCommon.configuration).apply
      else
        require 'figaro'
        FuseCommon::AirbrakeConfig.new(Figaro.env).apply
      end
    end
  end
end
