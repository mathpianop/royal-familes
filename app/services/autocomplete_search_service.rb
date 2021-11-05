class AutocompleteSearchService
  def initialize(query, options = {})
    @query = query
    @sex = options[:sex]
  end

  def call
    { people: people }
  end

  private

  def people
    @sex ? root_search.where(sex: @sex).take(10) : root_search.take(10)
  end


  def root_search
    Person.search_by_name_or_title(@query)
  end
end