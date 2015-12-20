json.array!(@users) do |user|
  json.extract! user, :id, :email, :nickname, :password, :phoneNum, :address
  json.url user_url(user, format: :json)
end
