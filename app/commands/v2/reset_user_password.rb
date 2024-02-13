class V2::ResetUserPassword < PowerTypes::Command.new(:user_type, :email, :request)
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
    @environment = @request.base_url.split('.').second
    input[:to] = 'emiliano@valuelist.cl' if @environment != 'valuelist'
    input[:vendor] = @vendor
    input[:substitutions] = {
      name: username,
      change_password_url: (front_base_url + CHANGE_PASSWORD_URL + '?token=' + token + '&type=' + @user.type).gsub('..', '.'),
      color: color,
      logo: logo
    }
    input[:default_sender] = 'emiliano@valuelist.cl'
    input[:template_id] = 'd-ca41e302e2f64c6182dfc2dee0f8077d'
    ResetPassword2Mailer.send(input)
  end

  def front_base_url
    vendor = 'ng' if @vendor == 'valuelist'
    vendor ||= @vendor
    url = "#{vendor}.#{@environment}.valuelist.cl"
    url = "app.valuelist.cl" if @environment == 'valuelist'
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
    url = 'http://cdn.mcauto-images-production.sendgrid.net/d66fb6464ef299a3/dc04c8f2-05f3-4d10-be2a-b00e01f6f2e5/921x73.png'
    url = 'http://cdn.mcauto-images-production.sendgrid.net/d66fb6464ef299a3/265265ff-4217-4b89-ab2e-edd3de8df7d3/921x85.png' if @vendor == 'valuecapital'
    url = 'http://cdn.mcauto-images-production.sendgrid.net/d66fb6464ef299a3/d7251348-58bc-44ff-ab21-f2c2c19def9c/938x77.png' if @vendor == 'greycapital'
    url = 'http://cdn.mcauto-images-production.sendgrid.net/d66fb6464ef299a3/722cdd58-fddc-4b35-9677-c1f720c5f3ba/763x65.png' if @vendor == 'tempus'
    url = 'http://cdn.mcauto-images-production.sendgrid.net/d66fb6464ef299a3/eea210c0-0630-4ecb-a4fa-4b3bfe8ba397/763x89.png' if @vendor == 'cyc'
    url
  end

  def main_app
    Rails.application.class.routes.url_helpers
  end
end
