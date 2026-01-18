class AddAbandonedToCarts < ActiveRecord::Migration[7.1]
  def up
    add_column :carts, :abandoned, :boolean, default: false
  end

  def down
    remove_column :carts, :abandoned
  end
end
