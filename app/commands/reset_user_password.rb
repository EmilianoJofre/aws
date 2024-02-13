class ResetUserPassword < PowerTypes::Command.new(:user_type, :email, :request)
  include Rails.application.routes.url_helpers

  HOST = ENV.fetch('APPLICATION_HOST')
  CHANGE_PASSWORD_URL = ENV.fetch('CHANGE_PASSWORD_URL')

  def perform
    return false if user.nil?

    token, enc_token = Devise.token_generator.generate(@user_type, :reset_password_token)
    @user.reset_password_token = enc_token
    @user.reset_password_sent_at = Time.now.utc

    if @user.save(validate: false)
      send_reset_password_email(@user.first_name, token)

      true
    end
  end

  private

  def user
    @user = @user_type.find_by(email: @email)
  end

  def send_reset_password_email(username, token)
    input = {}
    input[:to] = @email
    @vendor = @request.headers.include?('vendor') ? @request.headers['vendor'] : 'valuelist'
    input[:vendor] = @vendor
    input[:substitutions] = {
      name: username,
      change_password_url: @request.base_url + CHANGE_PASSWORD_URL + '?token=' + token + '&type=' + @user.type,
      color: color,
      logo: logo
    }
    input[:template_id] = 'd-dcabf2c39dac41d4ab46bcd8a9d819aa'
    ResetPassword2Mailer.send(input)
  end

  def front_base_url
    url = 'app.valuelist.cl'
    url = 'greycapital.valuelist.cl' if @vendor == 'greycapital'
    url = 'valuecapital.valuelist.cl' if @vendor == 'valuecapital'
    url = 'tempus.valuelist.cl' if @vendor == 'tempus'
    url = 'cyc.valuelist.cl' if @vendor == 'cyc'
    url
  end

  def color
    color = '#4F52FF'
    color = '#20B0FF' if @vendor == 'greycapital'
    color = '#435C95' if @vendor == 'valuecapital'
    color = '#BB3C5F' if @vendor == 'tempus'
    color = '#0BB868' if @vendor == 'cyc'
    color
  end

  def logo
    url = 'http://cdn.mcauto-images-production.sendgrid.net/91779574bc12e252/cc0a4075-796c-4cdd-bf9a-8a44c469140b/921x73.png'
    url = 'http://cdn.mcauto-images-production.sendgrid.net/91779574bc12e252/a663a21a-3058-4759-aba4-313eb746cdcb/921x85.png' if @vendor == 'valuecapital'
    url = 'http://cdn.mcauto-images-production.sendgrid.net/91779574bc12e252/a9d55585-37ae-435d-8a2d-806ee2e00763/938x77.png' if @vendor == 'greycapital'
    url = 'http://cdn.mcauto-images-production.sendgrid.net/91779574bc12e252/f0069cc8-d6c6-4333-ac84-54c20eb86178/763x65.png' if @vendor == 'tempus'
    url = 'http://cdn.mcauto-images-production.sendgrid.net/91779574bc12e252/2cd73b24-3fd4-45ef-aaad-92b94d739dde/763x89.png' if @vendor == 'cyc'
    url
  end

  def main_app
    Rails.application.class.routes.url_helpers
  end
end
