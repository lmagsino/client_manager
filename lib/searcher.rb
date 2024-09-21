class Searcher
  def initialize(clients)
    @clients = clients
  end

  def search_by_name(name_query)
    @clients.select { |client| client['full_name'].downcase.include?(name_query.downcase) }
  end
end
