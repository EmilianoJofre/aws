class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  ENVIRONMENT = ENV.fetch('ENV')
  TEST_MAIL = ENV.fetch('TEST_MAIL')
  DEFAULT_SENDER = ENV.fetch('DEFAULT_EMAIL_ADDRESS')
  SG_RESET_PASSWORD_TEMPLATE_ID = ENV.fetch('SG_RESET_PASSWORD_TEMPLATE_ID')
  
  def set_email email
    if ENVIRONMENT == 'production' then
      return email
    else 
      return TEST_MAIL
    end
  end


  def set_subj subj
    if ENVIRONMENT == 'production' then
      return subj
    elsif !$FRONT_ENV.nil?
      case $FRONT_ENV
      when 'local'
        return '[LOCAL] - ' + subj 
      when 'staging'
        return '[STAGING] - ' + subj 
      when 'QA'
        return '[QA] - ' + subj 
      when 'development'
        return '[DEV] - ' + subj 
      else
        return subj
      end
    else
      case ENVIRONMENT
      when 'production'
        return subj
      when 'development'
        return '[DEV] - ' + subj 
      when 'staging'
        return '[STAGING] - ' + subj 
      else
        return subj
      end  
    end
  end

  def set_reset_password_headers
    set_sender DEFAULT_SENDER
    set_template_id SG_RESET_PASSWORD_TEMPLATE_ID
  end
end
