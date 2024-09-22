require 'rspec'
require_relative '../lib/client_manager_app'
require_relative '../lib/json_loader'
require_relative '../lib/searcher'
require_relative '../lib/duplicate_checker'

RSpec.describe ClientManagerApp do
  let(:valid_clients) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@gmail.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@yahoo.com' },
      { 'id' => 3, 'full_name' => 'Another Jane Smith', 'email' => 'jane.smith@yahoo.com' }
    ]
  end

  let(:app) { ClientManagerApp.new }

  before do
    allow(JSONLoader).to receive(:load).and_return(valid_clients)
  end

  describe '#search' do
    it 'returns clients that match the search query' do
      results = app.search('Jane')
      expect(results.size).to eq(2)
      expect(results.map { |client| client['full_name'] }).to include('Jane Smith', 'Another Jane Smith')
    end

    it 'returns no clients if no matches are found' do
      results = app.search('Nonexistent Name')
      expect(results).to be_empty
    end
  end

  describe '#find_duplicates' do
    it 'finds clients with duplicate emails' do
      duplicates = app.find_duplicates
      expect(duplicates.keys).to include('jane.smith@yahoo.com')
      expect(duplicates['jane.smith@yahoo.com'].size).to eq(2)
    end

    it 'returns no duplicates if all emails are unique' do
      unique_clients = [
        { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@gmail.com' },
        { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@yahoo.com' }
      ]
      allow(JSONLoader).to receive(:load).and_return(unique_clients)

      new_app = ClientManagerApp.new
      duplicates = new_app.find_duplicates
      expect(duplicates).to be_empty
    end
  end

  describe '#initialize' do
    it 'loads clients correctly' do
      instance = ClientManagerApp.new
      expect(instance.instance_variable_get(:@clients)).to eq(valid_clients)
    end
  end
end
