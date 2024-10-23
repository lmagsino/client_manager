require 'rspec'
require_relative '../lib/client_manager_app'
require_relative '../lib/json_loader'
require_relative '../lib/searcher'
require_relative '../lib/duplicate_checker'
require_relative '../lib/indexer'

RSpec.describe ClientManagerApp do
  let(:default_json_path) { 'clients.json' }
  let(:valid_clients) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@gmail.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@yahoo.com' },
      { 'id' => 3, 'full_name' => 'Another Jane Smith', 'email' => 'jane.smith@yahoo.com' }
    ]
  end

  let(:app) { ClientManagerApp.new(default_json_path) }
  let(:indexer) { instance_double(Indexer) }
  let(:searcher) { instance_double(Searcher) }
  let(:duplicate_checker) { instance_double(DuplicateChecker) }

  before do
    allow(JSONLoader).to receive(:load).and_return(valid_clients)
    allow(Indexer).to receive(:new).and_return(indexer)
    allow(Searcher).to receive(:new).and_return(searcher)
    allow(DuplicateChecker).to receive(:new).and_return(duplicate_checker)
  end

  describe '#initialize' do
    it 'loads clients correctly' do
      expect(app.instance_variable_get(:@clients)).to eq(valid_clients)
    end

    it 'uses the provided JSON path' do
      ClientManagerApp.new(default_json_path)
      expect(JSONLoader).to have_received(:load).with(default_json_path)
    end

    it 'uses a custom JSON path when provided' do
      custom_path = 'custom/path/to/clients.json'
      ClientManagerApp.new(custom_path)
      expect(JSONLoader).to have_received(:load).with(custom_path)
    end
  end

  describe '#search' do
    it 'calls search_by_field on the searcher with the correct parameters' do
      allow(searcher).to receive(:search_by_field).with('full_name', 'Jane', case_sensitive: false).and_return([])
      app.search('full_name', 'Jane')
      expect(searcher).to have_received(:search_by_field).with('full_name', 'Jane', case_sensitive: false)
    end

    it 'returns the results from the searcher' do
      expected_results = [valid_clients[1], valid_clients[2]]
      allow(searcher).to receive(:search_by_field).and_return(expected_results)
      results = app.search('full_name', 'Jane')
      expect(results).to eq(expected_results)
    end
  end

  describe '#find_duplicates' do
    it 'calls find_duplicates on the duplicate_checker with the correct field' do
      allow(duplicate_checker).to receive(:find_duplicates).with('email').and_return({})
      app.find_duplicates('email')
      expect(duplicate_checker).to have_received(:find_duplicates).with('email')
    end

    it 'returns the results from the duplicate_checker' do
      expected_duplicates = { 'jane.smith@yahoo.com' => [valid_clients[1], valid_clients[2]] }
      allow(duplicate_checker).to receive(:find_duplicates).and_return(expected_duplicates)
      duplicates = app.find_duplicates('email')
      expect(duplicates).to eq(expected_duplicates)
    end
  end
end
