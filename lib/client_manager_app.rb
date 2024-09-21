require_relative 'json_loader'
require_relative 'searcher'
require_relative 'duplicate_checker'

class ClientManagerApp
  def initialize(file_path = 'clients.json')
    @clients = load_clients(file_path)
  end

  def search(term)
    Searcher.new(@clients).search_by_name(term)
  end

  def find_duplicates
    DuplicateChecker.new(@clients).find_duplicates
  end

  private

  def load_clients(file_path)
    clients = JSONLoader.load(file_path)
    if clients.empty?
      puts "Warning: No clients loaded from #{file_path}."
    end
    clients
  end
end
