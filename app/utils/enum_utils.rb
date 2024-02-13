class EnumUtils
  def self.enum_options_for_select(model, enum)
    model.send(enum.to_s.pluralize).map do |key, _|
      [enum_i18n(model, enum, key), key]
    end
  end

  def self.enum_i18n(model, enum, key)
    I18n.t("activerecord.enums.#{model.model_name.i18n_key}.#{enum.to_s.pluralize}.#{key}")
  end
end
