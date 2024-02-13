ActiveAdmin.register User do
  before_action :remove_password_params_if_blank, only: [:update]
  permit_params :email, :first_name, :last_name, :password, :password_confirmation

  menu label: 'Admins', priority: 3

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :phone_number
    column :institution
    column :email
    column :rut
    column :created_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :phone_number
  filter :created_at

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :phone_number
      f.input :institution
      f.input :email
      f.input :rut
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
      row :phone_number
      row :institution
      row :email
      row :rut
      row :created_at
      row :updated_at
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
