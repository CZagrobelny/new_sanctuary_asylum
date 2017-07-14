class Search

  attr_reader :model, :query, :page

  def initialize(model, query, page=nil)
    @query = query
    @model = model.classify.constantize
    @page = page
  end

  def perform
    model.search(query, page)
  end

end
