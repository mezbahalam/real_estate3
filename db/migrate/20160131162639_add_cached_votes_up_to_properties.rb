class AddCachedVotesUpToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :cached_votes_up, :integer, :default => 0
    add_index  :properties, :cached_votes_up
  end
end
