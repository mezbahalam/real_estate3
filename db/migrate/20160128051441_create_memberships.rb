class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user
      t.references :list

      t.timestamps null: false
    end

    add_index :memberships, ["user_id", "list_id"]
  end
end
