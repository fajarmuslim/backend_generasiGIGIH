class Common
  def self.delete_fields_from_params(params, delete_fields)
    delete_fields.each do |field|
      params.delete(field)
    end

    params
  end

  def self.extract_values_from_params(params)
    values = []

    params.each_value do |value|
      values << value
    end

    values
  end

  def self.extract_ids_from_array_obj(array_obj)
    ids = []
    array_obj.each do |obj|
      ids << obj.id
    end

    ids
  end
end