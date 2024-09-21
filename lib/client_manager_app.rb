require_relative 'json_loader'
require_relative 'searcher'
require_relative 'duplicate_checker'

class ClientManagerApp
  def initialize
    @clients = JSONLoader.load('clients.json')
  end

  def search(term)
    Searcher.new(@clients).search_by_name(term)
  end

  def find_duplicates
    DuplicateChecker.new(@clients).find_duplicates
  end
end
