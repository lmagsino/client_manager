require_relative '../client_manager_app'

class ClientManagerCLI
  def initialize
    @app = ClientManagerApp.new
  end

  def run
    command = ARGV[0]
    case command
    when 'search'
      search_term = ARGV[1]
      results = @app.search(search_term)
      if results.any?
        puts "Clients found:"
        results.each { |client| puts "#{client['full_name']} (#{client['email']})" }
      else
        puts "No clients found."
      end
    when 'duplicates'
      duplicates = @app.find_duplicates
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
