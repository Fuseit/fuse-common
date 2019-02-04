module FuseCommon
  module AirbrakeFilters
    class Request
      attr_accessor :request, :response

      def initialize request, response
        @request = request
        @response = response
      end

      def call notice
        notice[:params][:request] = request.to_h
        notice[:params][:response] = response.to_hash
      end
    end
  end
end
