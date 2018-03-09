require 'rails'
require 'airbrake'
require 'figaro'

module FuseCommon
  class Engine < Rails::Engine
    isolate_namespace FuseCommon

    initializer 'fuse_common.configure_airbrake' do
      require 'fuse_common/airbrake_config'
      FuseCommon::AirbrakeConfig.new(Figaro.env).apply
    end
  end
end
