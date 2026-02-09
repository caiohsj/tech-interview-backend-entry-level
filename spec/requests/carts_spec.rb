require 'rails_helper'

RSpec.describe '/cart', type: :request do
  describe 'POST /cart' do
    let(:product) { create(:product) }

    context 'when the cart does not exist' do
      it 'creates a new cart' do
        post '/cart', params: { product_id: product.id, quantity: 1 }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.parsed_body['id']).to be_present
        expect(response.parsed_body['products'].first['name']).to eq(product.name)
        expect(response.parsed_body['products'].first['quantity']).to eq(1)
        expect(response.parsed_body['products'].first['unit_price']).to eq(product.price.to_f)
        expect(response.parsed_body['products'].first['total_price']).to eq(product.price.to_f)
        expect(product.price.to_f).to eq(response.parsed_body['total_price'])
      end
    end
  end

  describe 'POST /add_item' do
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.from(1).to(2)
      end

      it 'updates the total price of the cart' do
        expect { subject }.to change { cart.reload.total_price }.by(product.price * 2)
      end
    end
  end

  describe 'GET /cart' do
    context 'when the cart does not exist' do
      it 'returns the cart empty' do
        get '/cart', as: :json
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['products']).to be_empty
        expect(response.parsed_body['total_price']).to be_zero
      end
    end

    context 'when the cart has products' do
      let(:product) { create(:product) }
      let(:cart) { create(:cart, total_price: product.price.to_f) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product) }
      
      it 'returns the cart with the products' do
        get '/cart', as: :json
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['products'].first['name']).to eq(product.name)
        expect(response.parsed_body['products'].first['quantity']).to eq(1)
        expect(response.parsed_body['products'].first['unit_price']).to eq(product.price.to_f)
        expect(response.parsed_body['products'].first['total_price']).to eq(product.price.to_f)
        expect(product.price.to_f).to eq(response.parsed_body['total_price'])
      end
    end
  end

  describe 'DELETE /cart/:product_id' do
    let(:product) { create(:product) }
    let(:cart) { create(:cart, total_price: product.price.to_f) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

    context 'when the product is in the cart' do
      it 'removes the product from the cart' do
        delete "/cart/#{product.id}", as: :json
        expect(response).to have_http_status(:ok)
      end

      it 'updates the total price of the cart' do
        expect { subject }.to change { cart.reload.total_price }.by(0)
      end
    end

    context 'when the product is not in the cart' do
      it 'returns a not found status' do
        delete "/cart/#{product.id + 1}", as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /cart' do
    let(:product) { create(:product) }
    let(:cart) { create(:cart, total_price: product.price.to_f) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

    it 'destroys the cart' do
      delete "/cart", as: :json
      expect(response).to have_http_status(:no_content)
      expect(Cart.count).to be_zero
    end
  end
end
