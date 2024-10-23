require_relative 'indexer'

class DuplicateChecker
  def initialize(indexer)
    @indexer = indexer
  end

  def find_duplicates(field)
    index = @indexer.build_index(field, prefix_index: false)
    index.select { |_, clients| clients.size > 1 }
  end
end
