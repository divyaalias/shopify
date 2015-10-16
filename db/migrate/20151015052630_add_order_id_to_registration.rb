class AddOrderIdToRegistration < ActiveRecord::Migration
  def change
  	add_column :registrations, :order_id, :integer
  end
end
