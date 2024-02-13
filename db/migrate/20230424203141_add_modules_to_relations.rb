class AddModulesToRelations < ActiveRecord::Migration[6.0]
  def change
    add_column :relations, :modules, :jsonb, default: { chart_currency_distribution_module: true, chart_country_distribution_module: true, chart_asset_type_distribution_module: true, chart_institution_distribution_module: true, chart_top_distribution_module: true, chart_asset_classify_distribution_module: true, chart_ambiental_vars_distribution_module:true }
  end
end
