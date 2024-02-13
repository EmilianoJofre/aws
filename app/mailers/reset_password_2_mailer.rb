require 'httparty'

class ResetPassword2Mailer < ApplicationMailer
  include HTTParty

  def self.send(input)
    headers = {
      'Authorization' => 'Bearer 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',
      'Content-Type' => 'application/json'
    }

    data = {
      personalizations: [
        {
          to: [
            {
              email: input[:to]
            }
          ],
          dynamic_template_data: input[:substitutions]
        }
      ],
      from: {
        email: input[:default_sender]
      },
      template_id: input[:template_id]
    }

    response = HTTParty.post('https://api.sendgrid.com/v3/mail/send', body: data.to_json, headers: headers)
    return response
  end
end
