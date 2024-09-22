class Searcher
  def initialize(clients)
    @clients = clients
    build_indices
  end

  # Build indices for quick lookups by full name
  def build_indices
    @name_index = Hash.new { |hash, key| hash[key] = [] }

    @clients.each do |client|
      full_name_downcase = client['full_name']&.downcase

      # Index clients by full_name
      @name_index[full_name_downcase] << client if full_name_downcase
    end
  end

  # Search for clients by name with support for partial matching
  def search_by_name(name_query, case_sensitive: false)
    regex = case_sensitive ? /#{Regexp.escape(name_query)}/ : /#{Regexp.escape(name_query)}/i

    # Search through the name index for matching clients
    @name_index.values.flatten.select do |client|
      full_name = case_sensitive ? client['full_name'] : client['full_name'].downcase
      full_name&.match?(regex)
    end
  end
end
