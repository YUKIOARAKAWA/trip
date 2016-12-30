json.array!(@places) do |place|
  json.extract! place, :id, :user_id, :plan_id, :address, :latitude, :longitude, :route
  json.url place_url(place, format: :json)
end
