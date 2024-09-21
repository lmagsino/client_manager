class Searcher
  def initialize(clients)
    @clients = clients
  end

  def search_by_name(name_query, case_sensitive: false)
    name_query = case_sensitive ? name_query : name_query.downcase
    @clients.select do |client|
      full_name = client['full_name']
      next if full_name.nil?

      case_sensitive ? full_name.include?(name_query) : full_name.downcase.include?(name_query)
    end
  end
end
