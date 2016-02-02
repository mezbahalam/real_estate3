class CreatePropertyships < ActiveRecord::Migration
  def change
    create_table :propertyships do |t|
      t.references :property
      t.references :list

      t.timestamps null: false
    end

    add_index :propertyships, ["list_id", "property_id"]
  end
end
