ActiveAdmin.register SubAccount do
  permit_params :sub_account_id

  menu label: 'Sub cuentas', parent: 'Inversionistas', priority: 7

  index do
    id_column
    column :currency
    column :sub_account_id
    column :account
    actions
  end

  form do |f|
    f.inputs do
      f.input :sub_account_id
    end
    f.actions
  end
end
