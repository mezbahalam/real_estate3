class CreateListsProperties < ActiveRecord::Migration
  def change
    create_table :lists_properties, :id => false do |t|
      t.integer :property_id
      t.integer :list_id
    end
  end
end
