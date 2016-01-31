class AddCachedVotesUpToLists < ActiveRecord::Migration
  def change
    add_column :lists, :cached_votes_up, :integer, :default => 0
    add_index  :lists, :cached_votes_up
  end
end
