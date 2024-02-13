# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Write the code in a way that can be executed multiple times without duplicating the information.
#
# For example:
#
# Country.create(name: "Chile") # BAD
# Country.find_or_create_by(name: "Chile") # GOOD
#

case Rails.env
when "development"
  vendor = Vendor.create(name: 'Grey Capital')

  Supervisor.create(email: 'supervisor@valuelist.cl', password: '123456', first_name: 'Supervisor', last_name: 'Apellido', rut: '11111111-1', vendor: vendor);

  Adviser.create(email: 'asesor@valuelist.cl', password: '123456', first_name: 'Asesor', last_name: 'Apellido', rut: '22222222-2')

  user = User.create(email: 'admin@valuelist.cl', first_name: 'Ricardo', last_name: 'García', rut: '33333333-3', password: '123456')

  Relation.create(email: 'investor@valuelist.cl', first_name: 'Ricardo', phone: '+56982960576', last_name: 'García', rut: '33333333-3', password: '123456', user: user)
end
