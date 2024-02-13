ActiveAdmin.register Bank do
  permit_params :name

  menu label: 'Instituciones', parent: 'Otros', priority: 11

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
