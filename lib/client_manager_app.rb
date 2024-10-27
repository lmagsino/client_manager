require_relative 'json_loader'
require_relative 'indexer'
require_relative 'searcher'
require_relative 'duplicate_checker'

class ClientManagerApp
  def initialize(file_path)
    @clients = load_clients(file_path)
  end

  def search(field, term, case_sensitive: false)
    return if @clients.empty?

    searcher.search_by_field(field, term, case_sensitive: case_sensitive)
  end

  def find_duplicates(field)
    return if @clients.empty?

    duplicate_checker.find_duplicates(field)
  end

  private

  def load_clients(file_path)
    clients = JSONLoader.load(file_path)
    if clients.empty?
      puts "Warning: No clients loaded from #{file_path}."
    end
    clients
  end

  def indexer
    @indexer ||= Indexer.new(@clients)
  end

  def searcher
    @searcher ||= Searcher.new(indexer)
  end

  def duplicate_checker
    @duplicate_checker ||= DuplicateChecker.new(indexer)
  end
end
