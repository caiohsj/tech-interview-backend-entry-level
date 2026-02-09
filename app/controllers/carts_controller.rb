class CartsController < ApplicationController
  def create
    cart = Cart.first_or_create(total_price: 0)
    cart.add_item(create_params)

    render json: cart, status: :created
  end

  def add_item
    cart = Cart.first_or_create(total_price: 0)
    cart.add_item(add_item_params)

    render json: cart, status: :success
  end

  def show
    cart = Cart.first_or_create(total_price: 0)
    render json: cart, status: :ok
  end

  def remove_item
    cart = Cart.first_or_create(total_price: 0)
    cart_item = cart.cart_items.find_by(product_id: params[:product_id])

    return render status: :not_found if cart_item.blank?

    cart.remove_item(cart_item)

    render json: cart, status: :ok
  end

  private

  def create_params
    params.permit(:product_id, :quantity)
  end

  def add_item_params
    params.permit(:product_id, :quantity)
  end

end
