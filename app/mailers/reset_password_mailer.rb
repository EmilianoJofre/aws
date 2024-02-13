class ResetPasswordMailer < ApplicationMailer

  def notify(username, email, reset_url)
    set_reset_password_headers
    subj = 'Recuperación de contraseña'
    subj = set_subj(subj)
    substitute("%name%", username)
    substitute("%email%", email)
    substitute("%resetUrl%", reset_url)
    substitute("%subject%", subj)
    set_subject(subj)
    mail(to: set_email(email), from: DEFAULT_SENDER )
  end
end
