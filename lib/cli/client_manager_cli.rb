require_relative '../client_manager_app'

class ClientManagerCLI
  DEFAULT_JSON_PATH = 'clients.json'
  SEARCH_FIELD = 'full_name'
  DUPLICATE_FIELD = 'email'

  def initialize
    @app = ClientManagerApp.new DEFAULT_JSON_PATH
    @commands = {
      'search' => method(:search),
      'duplicates' => method(:find_duplicates)
    }
  end

  def run
    command = ARGV[0]
    if @commands.key?(command)
      @commands[command].call(*ARGV[1..-1])
    else
      puts "Invalid command. Available commands: #{@commands.keys.join(', ')}"
    end
  end

  private

  def search(*args)
    search_term = args.join(' ')
    if search_term.nil? || search_term.strip.empty?
      puts 'Please provide a valid search term.'
      puts 'Usage: search <term>'
      return
    end
    results = @app.search(SEARCH_FIELD, search_term)
    display_search_results(results)
  end

  def find_duplicates
    duplicates = @app.find_duplicates(DUPLICATE_FIELD)
    display_duplicates(duplicates)
  end

  def display_search_results(results)
    return if results.nil?

    if results.any?
      puts 'Clients found:'
      results.each { |client| puts "#{client['full_name']} (#{client['email']})" }
    else
      puts 'No clients found.'
    end
  end

  def display_duplicates(duplicates)
    return if results.nil?

    if duplicates.any?
      puts "Duplicate emails found:"
      duplicates.each do |email, clients|
        puts "#{email}:"
        clients.each { |client| puts "  - #{client['full_name']} (#{client['email']})" }
      end
    else
      puts "No duplicate emails found."
    end
  end
end
