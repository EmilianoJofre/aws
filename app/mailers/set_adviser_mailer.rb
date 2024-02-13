require 'httparty'

class SetAdviserMailer < ApplicationMailer
  include HTTParty

  def send_adviser_email(support_email, investor_name)
    headers = {
      'Authorization' => 'Bearer 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',
      'Content-Type' => 'application/json'
    }

    data = {
      personalizations: [
        {
          to: [
            {
              email: support_email
            }
          ],
          dynamic_template_data: {
            investor_name: investor_name,
            color: '#20B0FF', # Color para "greycapital"
            logo: 'http://cdn.mcauto-images-production.sendgrid.net/d66fb6464ef299a3/d7251348-58bc-44ff-ab21-f2c2c19def9c/938x77.png' # Logo para "greycapital"
          }
        }
      ],
      from: {
        email: 'emiliano@valuelist.cl'
      },
      template_id: 'd-7b3df4a1b258428186546346bf28724e'
    }

    response = HTTParty.post('https://api.sendgrid.com/v3/mail/send', body: data.to_json, headers: headers)

    if response.success?
      # El correo se envió exitosamente
    else
      Rails.logger.error("Error al enviar el correo electrónico: #{response.body}")
    end
  end
end
