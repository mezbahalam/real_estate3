class AddOwnerIdToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :owner_id, :integer
  end
end
