json.array!(@posts) do |post|
  json.extract! post, :id, :user_id, :title, :content, :time, :status_id, :tag_id
  json.url post_url(post, format: :json)
end
