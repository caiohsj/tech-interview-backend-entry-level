require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
    it 'marks the cart as abandoned' do
        Sidekiq::Testing.inline! do
            cart = Cart.create(total_price: 100, last_interaction_at: 4.hours.ago)
            MarkCartAsAbandonedJob.perform_async
            expect(cart.reload.abandoned?).to be_truthy
        end
    end

    it 'removes the cart if abandoned more than 7 days' do
        Sidekiq::Testing.inline! do
            cart = Cart.create(total_price: 100, abandoned: true, last_interaction_at: 8.days.ago)
            MarkCartAsAbandonedJob.perform_async
            expect(Cart.count).to eq(0)
        end
    end
end
