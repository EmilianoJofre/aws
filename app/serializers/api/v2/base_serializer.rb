class Api::V2::BaseSerializer < ActiveModel::Serializer
  ActiveModel::Serializer.config.adapter = :json
  ActiveModelSerializers.config.json_include_toplevel_object = false

  def deep?
    @instance_options[:deep]
  end

  def real_estate?
    @instance_options[:real_estate]
  end

  def sub_accounts?
    @instance_options[:sub_accounts]
  end

  def memberships?
    @instance_options[:memberships]
  end

  def resume?
    @instance_options[:resume]
  end

  private

  def puts_association(serializer)
    {
      id: serializer.object.id.to_s,
      attributes: serializer.attributes
    }
  end

  def rut_number str
    rut_clean(str)[0...-1]
  end

  def rut_dv str
    rut_clean(str)[-1..-1]
  end

  def rut_clean str
    str.delete(' ').delete('.').delete('-')
  end

  def date_concise date
    I18n.l(date, format: :dateconcise)
  end

  def date_time_concise date
    I18n.l(date, format: :date_time_concise)
  end  
end
