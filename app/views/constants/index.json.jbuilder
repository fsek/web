json.array!(@constants) do |constant|
  json.extract! constant, :id, :name, :value
  json.url constant_url(constant, format: :json)
end
