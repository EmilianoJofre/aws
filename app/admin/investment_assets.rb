ActiveAdmin.register InvestmentAsset do
  permit_params :name, :asset_id, :currency, :valid_asset, :asset_type

  menu label: 'Instrumentos', parent: 'Otros', priority: 12

  index do
    selectable_column
    id_column
    column :name
    column :asset_id
    column :currency
    toggle_bool_column :valid_asset
    column :asset_type
    actions
  end

  collection_action :add_country_file_form, title: 'Subir archivo con paises' do
  end

  action_item :upload_file, only: :index do
    link_to( 'Subir archivo con paises', add_country_file_form_admin_investment_assets_path)
  end

  collection_action :add_country_file, title: 'add_country_file', method: :post do
    file = params[:countries][:file]

    file_type = file.original_filename.split('.')[-1]
    if ['xls', 'xlsx'].include? file_type
      ProcessCountriesUpdateFile.for(file: file)
      redirect_to admin_investment_assets_path, notice: 'Se han actualizando los paises'
    else
      redirect_to admin_investment_assets_path, alert: I18n.t(
        'active_admin.price_change.add_file_error'
      )
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :asset_id
      f.input :currency, as: :select, collection:  InvestmentAsset.currency.values
      f.input :asset_type, as: :select, collection:  InvestmentAsset.asset_types.keys
      f.input :valid_asset, as: :boolean
    end
    f.actions
  end
end
