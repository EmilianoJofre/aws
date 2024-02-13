module ApiErrorConcern
  extend ActiveSupport::Concern

  included do
    rescue_from "Exception" do |exception|
      logger.error exception.message
      logger.error exception.backtrace.join("\n")
      Raven.capture_exception("#{exception.message} \n#{exception.backtrace.join("\n")}")
      respond_api_error(:internal_server_error, message: "server_error",
                                                type: exception.class.to_s,
                                                detail: exception.message)
    end

    rescue_from "Pundit::NotAuthorizedError" do |exception|
      respond_api_error(:unauthorized, message: "not_authorized", errors: exception.message)
    end

    rescue_from "ValueListErrors::AuthenticationError" do |exception|
      respond_api_error(:unauthorized, message: "not_authorized", errors: exception.message)
    end

    rescue_from "ActiveRecord::RecordNotFound" do |exception|
      respond_api_error(:not_found, message: "record_not_found",
                                    detail: exception.message)
    end

    rescue_from "ActiveModel::ForbiddenAttributesError" do |exception|
      respond_api_error(:bad_request, message: "protected_attributes",
                                      detail: exception.message)
    end

    rescue_from "ActiveRecord::RecordInvalid" do |exception|
      respond_api_error(:bad_request, message: "invalid_attributes",
                                      errors: exception.record.errors)
    end

    rescue_from "PowerApi::InvalidVersion" do |exception|
      respond_api_error(:bad_request, message: "invalid_api_version",
                                      errors: exception.message)
    end
  end
end
