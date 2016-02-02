class AddPropertyIdToLists < ActiveRecord::Migration
  def change
    add_column :lists, :property_id, :integer

  end
end
