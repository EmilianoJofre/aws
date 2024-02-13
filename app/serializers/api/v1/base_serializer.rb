class Api::V1::BaseSerializer < ActiveModel::Serializer
  ActiveModel::Serializer.config.adapter = :json
  def deep?
    @instance_options[:deep]
  end

  def sub_accounts?
    @instance_options[:sub_accounts]
  end

  def memberships?
    @instance_options[:memberships]
  end
  
  private

  def puts_association(serializer)
    {
      id: serializer.object.id.to_s,
      attributes: serializer.attributes
    }
  end

  def date_concise date
    I18n.l(date, format: :dateconcise)
  end

  def date_time_concise date
    I18n.l(date, format: :date_time_concise)
  end
end
