require 'rspec'
require_relative '../lib/client_manager_app'
require_relative '../lib/json_loader'
require_relative '../lib/searcher'
require_relative '../lib/duplicate_checker'
require_relative '../lib/indexer'

RSpec.describe ClientManagerApp do
  let(:valid_clients) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@gmail.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@yahoo.com' },
      { 'id' => 3, 'full_name' => 'Another Jane Smith', 'email' => 'jane.smith@yahoo.com' }
    ]
  end

  let(:app) { ClientManagerApp.new }
  let(:indexer) { instance_double(Indexer) }
  let(:searcher) { instance_double(Searcher) }
  let(:duplicate_checker) { instance_double(DuplicateChecker) }

  before do
    allow(JSONLoader).to receive(:load).and_return(valid_clients)
    allow(Indexer).to receive(:new).and_return(indexer)
    allow(Searcher).to receive(:new).and_return(searcher)
    allow(DuplicateChecker).to receive(:new).and_return(duplicate_checker)
  end

  describe '#search' do
    it 'returns clients that match the search query' do
      allow(searcher).to receive(:search_by_field).with('full_name', 'Jane', case_sensitive: false).and_return(valid_clients[1..2])

      results = app.search('full_name', 'Jane')
      expect(results.size).to eq(2)
      expect(results.map { |client| client['full_name'] }).to include('Jane Smith', 'Another Jane Smith')
    end

    it 'returns no clients if no matches are found' do
      allow(searcher).to receive(:search_by_field).with('full_name', 'Nonexistent Name', case_sensitive: false).and_return([])

      results = app.search('full_name', 'Nonexistent Name')
      expect(results).to be_empty
    end
  end

  describe '#find_duplicates' do
    it 'finds clients with duplicate emails' do
      allow(duplicate_checker).to receive(:find_duplicates).with('email').and_return({
        'jane.smith@yahoo.com' => valid_clients[1..2]
      })

      duplicates = app.find_duplicates('email')
      expect(duplicates.keys).to include('jane.smith@yahoo.com')
      expect(duplicates['jane.smith@yahoo.com'].size).to eq(2)
    end

    it 'returns no duplicates if all emails are unique' do
      allow(duplicate_checker).to receive(:find_duplicates).with('email').and_return({})

      duplicates = app.find_duplicates('email')
      expect(duplicates).to be_empty
    end
  end

  describe '#initialize' do
    it 'loads clients correctly' do
      expect(app.instance_variable_get(:@clients)).to eq(valid_clients)
    end
  end
end
