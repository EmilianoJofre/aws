ActiveAdmin.register Adviser do
  before_action :remove_password_params_if_blank, only: [:update]
  permit_params :first_name, :last_name, :rut, :phone, :active, :email, :password, :password_confirmation

  menu label: 'Asesores', priority: 7
  
  index do
    id_column
    column :first_name
    column :last_name
    column :email
    column :rut
    column :phone
    column :supervisors
    column :active
    actions
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :supervisors

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :rut
      f.input :phone
      f.input :password
      f.input :password_confirmation
      f.input :active
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :email
      row :rut
      row :phone
      row :supervisors
      row :active
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
