ActiveAdmin.register PriceChange do
  permit_params :value, :price_changed_at, :investment_asset

  menu label: 'Precios', priority: 10

  index do
    id_column
    column :value
    column :price_changed_at
    column :investment_asset
    column :created_at
    actions
  end

  collection_action :add_file_form, title: I18n.t('active_admin.price_change.add_file') do
  end

  action_item :upload_file, only: :index do
    link_to(I18n.t('active_admin.price_change.add_file'), add_file_form_admin_price_changes_path)
  end

  collection_action :add_file, title: I18n.t('active_admin.download.add_file'), method: :post do
    file = params[:price_changes][:file]

    file_type = file.original_filename.split('.')[-1]
    if ['xls', 'xlsx'].include? file_type
      ProcessPriceChangesFile.for(file: file)
      redirect_to admin_price_changes_path, notice: I18n.t(
        'active_admin.price_change.add_file_success'
      )
    else
      redirect_to admin_price_changes_path, alert: I18n.t(
        'active_admin.price_change.add_file_error'
      )
    end
  end
end
