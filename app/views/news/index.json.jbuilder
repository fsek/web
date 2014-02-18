json.array!(@news) do |news|
  json.extract! news, :id, :title, :content
  json.url news_url(news, format: :json)
end
