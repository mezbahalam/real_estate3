class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :street_address
      t.string :city
      t.string :state
      t.float :lat
      t.float :lon
      t.string :url
      t.string :photo_url
      t.text :description
      t.string :tags
      t.integer :bedroom
      t.integer :bathroom
      t.float :price
      t.string :status
      t.references :list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
