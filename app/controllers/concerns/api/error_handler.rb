module Api
  module ErrorHandler
    extend ActiveSupport::Concern
    include ExceptionHandlers

    # rescue_from statements below are executed first, order exceptions accordingly
    included do
      rescue_from StandardError do |exception|
        internal_server_error(exception)
      end
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      rescue_from ActiveRecord::RecordInvalid do |exception|
        render_form_validation_errors(exception.record)
      end
    end

    def not_found
      render_error(:not_found, I18n.t('general.not_found'))
    end

    def render_form_validation_errors(record)
      render_error(:unprocessable_entity, I18n.t('general.validation_failed'), record.errors)
    end

    def render_first_validation_error(record)
      render_error(:unprocessable_entity, record.errors.first.to_sentence)
    end

    def internal_server_error(exception)
      log_and_report(exception, {params: params.to_json, request_body: request.body.to_json,
                                 current_user_id: current_user.id}, 'web')
      render_error(:internal_server_error, I18n.t('general.something_went_wrong'))
    end

    def render_error(status, error = '', errors = [])
      render json: { error: error, errors: errors }, status: status
    end

    def logger
      api_logger
    end

    def api_logger
      @auth_logger ||= Logger.new("#{Rails.root}/log/api.log", level: Rails.logger.level)
    end
  end
end
