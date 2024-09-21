class DuplicateChecker
  def initialize(clients)
    @clients = clients
  end

  def find_duplicates
    grouped_by_email = @clients.group_by { |client| client['email'] }
    grouped_by_email.select { |email, clients| clients.size > 1 }
  end
end
