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

    # Search through the keys of @name_index for matching full names and return the matching clients
    @name_index.keys.grep(regex).flat_map { |full_name| @name_index[full_name] }
  end
end
