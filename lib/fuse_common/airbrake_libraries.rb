module FuseCommon
  class AirbrakeLibraries
    # It's original airbrake.rb with additional condition of Rails::Railtie existence
    def self.load
      return if defined?(Airbrake)

      require 'shellwords'
      require 'English'
      require 'airbrake-ruby'
      require 'airbrake/version'

      if defined?(Rack)
        require 'airbrake/rack'
        require 'airbrake/rails' if defined?(Rails) && defined?(Rails::Railtie)
      end

      require 'airbrake/rake' if defined?(Rake::Task)
      require 'airbrake/resque' if defined?(Resque)
      require 'airbrake/sidekiq' if defined?(Sidekiq)
      require 'airbrake/shoryuken' if defined?(Shoryuken)
      require 'airbrake/delayed_job' if defined?(Delayed)
      require 'airbrake/sneakers' if defined?(Sneakers)
      require 'airbrake/logger'

      at_exit do
        Airbrake.notify_sync($ERROR_INFO) if $ERROR_INFO
        Airbrake.close
      end
    end
  end
end
