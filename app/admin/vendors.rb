ActiveAdmin.register Vendor do
  permit_params :name, :vars

  menu label: 'Vendors', priority: 4

  index do
    id_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :vars
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :vars
    end
  end
end
