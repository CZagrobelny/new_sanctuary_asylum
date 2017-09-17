#This class is a wrapper on the textacular gem
#for more information https://github.com/textacular/textacular
class Search

  attr_reader :model, :query, :page

  def initialize(model, query, page=nil)
    @query = query
    @model = model.classify.constantize
    @page = page
  end

  def perform
    search.paginate(page: page)
  end

  private

  def search
    if query_string_length > 1 
      search_attributes
    else
      search
    end
  end

  def search_attributes 
    #You should be able to add other attributes to this 
    #search. Attributes not on the model will be ignored.
    model.advanced_search(first_name: sanitize_query, 
                          last_name: sanitize_query)

  end

  def search
    model.advanced_search(sanitize_query)
  end

  def sanitize_query
    ## remove special characters that textacular uses for search
    query.gsub!(/[&|!]/,'')
    ## make sure that the query does not have extra spaces
    query.split(' ').join('|')
  end

  def query_string_length
    sanitize_query.schan(/\|/).count
  end

end
