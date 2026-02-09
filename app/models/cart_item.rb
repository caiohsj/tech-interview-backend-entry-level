class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates_numericality_of :quantity, greater_than_or_equal_to: 0

  def name
    product.name
  end

  def unit_price
    product.price.to_f
  end

  def total_price
    product.price.to_f * quantity
  end
end
