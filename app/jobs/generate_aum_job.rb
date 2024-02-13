class GenerateAumJob < ApplicationJob
  queue_as :stats

  def perform(*args)
    data = Relation.all    
    if args.count == 0 then
      process_date = Time.current
      serializer = ActiveModelSerializers::SerializableResource.new(data, each_serializer: Api::V1::AumDataSerializer, root: 'clients')
    else
      process_date = args[0].to_date
      serializer = ActiveModelSerializers::SerializableResource.new(data, each_serializer: Api::V1::AumDataSerializer, root: 'clients', date: args[0])
    end
    Aum.where(created_at: process_date.all_day).empty? ? Aum.create(aum: serializer.to_json, created_at: process_date) : "El AUM del día ya fue generado"
  end
end
