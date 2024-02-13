ActiveAdmin.register Account do
  permit_params :name, :rut, :email

  menu label: 'Cuentas', parent: 'Inversionistas', priority: 6

  index do
    id_column
    column :name
    column :rut
    column :email
    column :bank
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :rut
      f.input :email
    end
    f.actions
  end
end
