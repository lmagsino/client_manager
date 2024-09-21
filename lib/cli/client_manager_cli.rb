require_relative 'json_loader'
require_relative 'searcher'
require_relative 'duplicate_checker'

class CLI
  def initialize
    @clients = JSONLoader.load('clients.json')
  end

  def run
    command = ARGV[0]
    case command
    when 'search'
      search_term = ARGV[1]
      results = Searcher.new(@clients).search_by_name(search_term)
      if results.any?
        puts "Clients found:"
        results.each { |client| puts "#{client['full_name']} (#{client['email']})" }
      else
        puts "No clients found."
      end
    when 'duplicates'
      duplicates = DuplicateChecker.new(@clients).find_duplicates
      if duplicates.any?
        puts "Duplicate Emails found:"
        duplicates.each do |email, clients|
          clients.each { |client| puts "#{client['full_name']} (#{client['email']})" }
        end
      else
        puts "No duplicate emails found."
      end
    else
      puts "Invalid command. Use 'search' or 'duplicates'."
    end
  end
end
