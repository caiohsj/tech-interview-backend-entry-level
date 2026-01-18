require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe 'mark_as_abandoned' do
    let(:shopping_cart) { create(:cart) }

    it 'marks the shopping cart as abandoned if inactive for a certain time' do
      Sidekiq::Testing.inline! do
        shopping_cart.update(last_interaction_at: 3.hours.ago)
        MarkCartAsAbandonedJob.perform_async
        expect(shopping_cart.reload.abandoned?).to be_truthy
      end
    end
  end

  describe 'remove_if_abandoned' do
    it 'removes the shopping cart if abandoned for a certain time' do
      Sidekiq::Testing.inline! do
        shopping_cart = create(:cart, :available_to_remove)
        MarkCartAsAbandonedJob.perform_async
        expect(Cart.find_by(id: shopping_cart.id)).to be_nil
      end
    end
  end
end
