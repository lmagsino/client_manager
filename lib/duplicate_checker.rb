class DuplicateChecker
  def initialize(clients)
    @clients = clients
    build_email_index
  end

  # Build an index for quick lookups by email
  def build_email_index
    @email_index = Hash.new { |hash, key| hash[key] = [] }

    @clients.each do |client|
      email = client['email']
      # Index clients by email
      @email_index[email] << client if email
    end
  end

  # Find duplicates based on indexed emails
  def find_duplicates
    # Select emails with more than one associated client
    @email_index.select { |_, clients| clients.size > 1 }
  end
end
