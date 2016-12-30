json.array!(@blogs) do |blog|
  json.extract! blog, :id, :Test, :name
  json.url blog_url(blog, format: :json)
end
