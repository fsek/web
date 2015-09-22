json.array!(@ex_links) do |ex_link|
  json.extract! ex_link, :id, :label, :url, :tags, :test_availability, :note, :active, :expiration
  json.url ex_link_url(ex_link, format: :json)
end
