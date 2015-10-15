json.array!(@orders) do |order|
  json.extract! order, :id, :name, :quantity, :price
  json.url order_url(order, format: :json)
end
