class ApplicationController < ActionController::Base
  include PowerTypes::Presentable

  before_action :set_front_vars

  protect_from_forgery with: :exception

  # acts_as_token_authentication_handler_for User
  def after_sign_in_path_for(*)
    case resource_name
    when :user
      relations_path
    when :relation
      return relation_path(resource&.id) unless current_relation

      relation_path(current_relation.id)
    else
      root_path
    end
  end

  def set_front_vars
    $FRONT_ENV = request.headers.include?('environment') ? request.headers['environment'] : nil
    $VENDOR = request.headers.include?('vendor') ? request.headers['vendor'] : 'valuelist' # TODO: Usar esta variable en todas las partes en que se use el Vendor desde los headers

    base_url = ENV.fetch('FRONT_BASE_URL').dup
    if request.headers.include?('environment') then
      case $FRONT_ENV
      when 'local'
        base_url.gsub! 'dev', 'dev'
      when 'staging'
        base_url.gsub! 'dev', 'staging'
      when 'QA'
        base_url.gsub! 'dev', 'qa'
      when 'development'
        base_url.gsub! 'dev', 'dev'
      end
    end
    $FRONT_BASE_URL = base_url
  end
end
