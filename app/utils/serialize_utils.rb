module SerializeUtils
  extend self

  def map(resources, options = {})
    ActiveModel::Serializer::CollectionSerializer.new(
      resources,
      options
    )
  end

  def serializer_for(resource)
    ActiveModel::Serializer.serializer_for(resource, { namespace: 'Api::V1' })
  end

  def to_hash(resource)
    serializer = serializer_for(resource)
    serializer ? serializer.new(resource).to_h : resource.to_h
  end

  def to_json(resource)
    serializer = serializer_for(resource)
    serializer ? serializer.new(resource).to_json : resource.to_json
  end

  def as_json(resource)
    serializer = serializer_for(resource)
    serializer ? serializer.new(resource).as_json : resource.as_json
  end

  def as_json_value(resource)
    as_json(resource)[model_name_underscore(resource)]
  end

  def to_json_value(resource)
    return unless resource

    as_json(resource)[model_name_underscore(resource)].to_json
  end

  def map_to_json(resources, options = {})
    map(resources, options).to_json
  end

  def map_as_json(resources, options = {})
    map(resources, options).as_json
  end

  def hash_to_json(resources_hash)
    apply_serializer_to_resources_hash(resources_hash).to_json
  end

  private

  def model_name_underscore(resource)
    resource.class.name.underscore
  end

  def apply_serializer_to_resources_hash(resources_hash)
    resources_hash.map do |_, value|
      if value.is_a?(Hash)
        [_, apply_serializer_to_resources_hash(value)]
      else
        [_, JSON.parse(SerializeUtils.map_to_json(value))]
      end
    end.to_h
  end
end
