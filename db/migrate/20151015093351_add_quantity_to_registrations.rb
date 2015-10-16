class AddQuantityToRegistrations < ActiveRecord::Migration
  def change
  	add_column :registrations, :quantity, :integer
  end
end
