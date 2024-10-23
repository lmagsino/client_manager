require_relative 'indexer'

class Searcher
  def initialize(indexer)
    @indexer = indexer
  end

  def search_by_field(field, query, case_sensitive: false)
    index = @indexer.build_index(field, prefix_index: true)
    search_query = case_sensitive ? query : query.downcase
    regex = /#{Regexp.escape(search_query)}/i
    index.keys.grep(regex).flat_map { |key| index[key] }.uniq
  end
end
