ActiveAdmin.register Relation do
  before_action :remove_password_params_if_blank, only: [:update]
  permit_params :id, :first_name, :last_name, :rut, :email, :phone, :password, :password_confirmation

  menu label: 'Inversionistas', parent: 'Inversionistas', priority: 5

  index do
    id_column
    column :first_name
    column :last_name
    column :rut
    column :email
    column :phone
    actions
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :rut
      f.input :email
      f.input :phone
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :rut
      row :email
      row :phone
    end
  end

  controller do
    def remove_password_params_if_blank
      if params[:relation][:password].blank? && params[:relation][:password_confirmation].blank?
        params[:relation].delete(:password)
        params[:relation].delete(:password_confirmation)
      end
    end
  end
end
