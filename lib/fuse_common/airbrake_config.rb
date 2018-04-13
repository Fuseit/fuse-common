require 'fuse_common/airbrake_libraries'

module FuseCommon
  class AirbrakeConfig
    class RequiredKeyMissed < StandardError; end

    def initialize env, overrides = {}
      @env = env
      @overrides = overrides
    end

    def apply
      require_airbrake

      configure_airbrake do |config|
        config.environment         = setting(:stack_name) || rails_env
        config.ignore_environments = ignored_environments

        apply_project_settings config

        yield config if block_given?
      end
    end

    private

      attr_reader :env, :overrides

      # `project_id` and `project_key` are required to be filled even for ignored environments,
      # so we have to setup dummy values
      # TODO: this behavior was changed in `airbrake-ruby` 2.8.5, so remove dummy values after upgrading
      # https://github.com/airbrake/airbrake/issues/552
      # https://github.com/airbrake/airbrake-ruby/commit/59507aa3a38cefeb35c76f50f7783084a8c6e7ad
      def apply_project_settings config
        config.project_id  = setting(:airbrake_project_id)  || fetch_defaults!(:airbrake_project_id)
        config.project_key = setting(:airbrake_project_key) || fetch_defaults!(:airbrake_project_key)
      end

      def require_airbrake
        AirbrakeLibraries.load
      end

      def configure_airbrake &block
        Airbrake.configure(&block)
      end

      def setting name
        env.send(name).presence || overrides[name].presence
      end

      def dummy_value
        rails_env
      end

      def rails_env
        @rails_env ||= setting(:rails_env) || 'development'
      end

      def ignored_environments
        @ignored_environments ||= overrides.fetch :ignore_environments, default_ignored_environments
      end

      def ignored_environment?
        ignored_environments.include? rails_env
      end

      def default_ignored_environments
        %w(development test)
      end

      def fetch_defaults! key
        ignored_environment? ? dummy_value : raise_key_missed_error(key)
      end

      def raise_key_missed_error key
        raise RequiredKeyMissed, "required '#{key}' key is missed or empty"
      end
  end
end
