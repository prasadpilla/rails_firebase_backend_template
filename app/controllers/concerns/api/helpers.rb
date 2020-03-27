module Api
  module Helpers
    extend ActiveSupport::Concern

    def json_request?
      request.format.json?
    end

    def render_created
      render json: {}, status: :created
    end

    def render_ok
      render json: {}, status: :ok
    end
  end
end
