class SearchSuggestion < ActiveRecord::Base
  def self.terms_for(prefix)
    suggestions = where("term like ?", "#{prefix}_%")
    suggestions.order("popularity desc").limit(10).map(&:term)
  end

  def self.index_lists
    List.find_each do |list|
      index_term(list.name)
    end
    Property.find_each do |list|
      index_term(list.street_address)
    end

  end

  def self.index_term(term)
    where(term: term.downcase).first_or_initialize.tap do |suggestion|
      suggestion.increment! :popularity
    end
  end
end
