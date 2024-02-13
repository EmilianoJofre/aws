class Api::V1::AumSerializer < Api::V1::BaseSerializer
  # ActiveModel::Serializer.config.adapter = :attributes
  attributes :date, :clients

  def date
    object.created_at.strftime('%m/%d/%Y')
  end

  def clients
    JSON.parse(object.aum)
  end
end
