class AddLastInteractionAtToCarts < ActiveRecord::Migration[7.1]
  def up
    add_column :carts, :last_interaction_at, :datetime
  end

  def down
    remove_column :carts, :last_interaction_at
  end
end
