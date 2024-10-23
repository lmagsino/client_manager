require_relative '../client_manager_app'

class ClientManagerCLI
  def initialize
    @app = ClientManagerApp.new
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
      puts "Invalid command."
    end
  end

  private

  def search(search_term)
    if search_term.nil? || search_term.strip.empty?
      puts 'Please provide a valid search term.'
      return
    end
    results = @app.search(search_term)
    display_search_results(results)
  end

  def find_duplicates()
    duplicates = @app.find_duplicates
    display_duplicates(duplicates)
  end

  def display_search_results(results)
    if results.any?
      puts 'Clients found:'
      results.each { |client| puts "#{client['full_name']} (#{client['email']})" }
    else
      puts 'No clients found.'
    end
  end

  def display_duplicates(duplicates)
    if duplicates.any?
      puts "Duplicate Emails found:"
      duplicates.each do |email, clients|
        puts "#{email}:"
        clients.each { |client| puts "  - #{client['full_name']} (#{client['email']})" }
      end
    else
      puts "No duplicate emails found."
    end
  end
end
