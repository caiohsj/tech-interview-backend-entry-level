require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context 'when validating' do
    it 'validates presence of product' do
      item = described_class.new(cart: create(:cart))
      expect(item.valid?).to be_falsey
      expect(item.errors[:product]).to include("must exist")
    end

    it 'validates presence of cart' do
      item = described_class.new(product: create(:product))
      expect(item.valid?).to be_falsey
      expect(item.errors[:cart]).to include("must exist")
    end

    it 'validates numericality of quantity' do
      item = described_class.new(cart: create(:cart), product: create(:product), quantity: -1)
      expect(item.valid?).to be_falsey
      expect(item.errors[:quantity]).to include("must be greater than or equal to 0")
    end
  end
end
