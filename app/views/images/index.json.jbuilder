json.array!(@image) do |image|
  json.extract! image, 
  json.url image_url(image, format: :json)
end