module FuseCommon
  class Configuration
    attr_accessor :airbrake_project_id, :airbrake_project_key, :airbrake_environment_name, :rails_env

    def initialize
      @airbrake_project_id = nil
      @airbrake_project_key = nil
      @airbrake_environment_name = Rails.env
      @rails_env = Rails.env
    end
  end
end
