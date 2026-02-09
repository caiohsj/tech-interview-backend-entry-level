class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  has_many :cart_items, dependent: :destroy

  def mark_as_abandoned
    update(abandoned: true)
  end

  def add_item(params)
    ActiveRecord::Base.transaction do
      cart_item = cart_items.find_or_initialize_by(product_id: params[:product_id])
      cart_item.quantity = (cart_item.quantity || 0) + params[:quantity]
      cart_item.save

      self.total_price += cart_item.product.price * cart_item.quantity
      save!
      cart_item
    end
  end

  def remove_item(cart_item)
    ActiveRecord::Base.transaction do
      cart_item.destroy
      self.total_price -= cart_item.product.price * cart_item.quantity
      save!  
    end
  end

end
