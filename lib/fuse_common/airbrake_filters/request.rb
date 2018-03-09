module FuseCommon
  module AirbrakeFilters
    class Request < Struct.new(:request, :response)
      def call notice
        notice[:params][:request]  = request.to_h
        notice[:params][:response] = response.to_hash
      end
    end
  end
end
