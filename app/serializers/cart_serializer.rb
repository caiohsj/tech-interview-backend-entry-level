class CartSerializer < ActiveModel::Serializer
  attributes :id, :products, :total_price

  def products
    ActiveModel::Serializer::CollectionSerializer.new(object.cart_items, each_serializer: CartItemSerializer)
  end

  def total_price
    object.total_price.to_f
  end

end
