class MarkCartAsAbandonedJob
  include Sidekiq::Job
  queue_as :default

  def perform
    carts_without_interaction = Cart.where(last_interaction_at: ..3.hours.ago)
    carts_without_interaction.each do |cart|
      cart.mark_as_abandoned
    end

    carts_abandoned_more_than_7_days = Cart.where(abandoned: true, last_interaction_at: ..7.days.ago)
    carts_abandoned_more_than_7_days.each do |cart|
      cart.destroy
    end
  end
end
