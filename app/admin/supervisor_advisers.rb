ActiveAdmin.register SupervisorAdviser do
  permit_params :id, :supervisor_id, :adviser_id

  menu label: 'Supervisor/Asesor', priority: 6

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :supervisor_id, :adviser_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:supervisor_id, :adviser_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
