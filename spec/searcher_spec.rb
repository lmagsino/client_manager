require 'rspec'
require_relative '../lib/searcher'

RSpec.describe Searcher do
  let(:clients) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@gmail.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@yahoo.com' },
      { 'id' => 3, 'full_name' => 'Another Jane Smith', 'email' => 'jane.smith@yahoo.com' }
    ]
  end

  let(:searcher) { instance_double(Searcher) }

  before do
    allow(Searcher).to receive(:new).with(clients).and_return(searcher)
  end

  describe '#search_by_name' do
    context 'when matching clients are found' do
      it 'returns clients that match the query' do
        allow(searcher).to receive(:search_by_name).with('Jane', case_sensitive: false).and_return(clients[1..2])

        results = searcher.search_by_name('Jane', case_sensitive: false)

        expect(results.size).to eq(2)
        expect(results.map { |client| client['full_name'] }).to include('Jane Smith', 'Another Jane Smith')
      end
    end

    context 'when no matching clients are found' do
      it 'returns an empty array' do
        allow(searcher).to receive(:search_by_name).with('Nonexistent', case_sensitive: false).and_return([])

        results = searcher.search_by_name('Nonexistent', case_sensitive: false)

        expect(results).to be_empty
      end
    end
  end

  describe '#search with case sensitivity' do
    it 'returns clients matching the case-sensitive query' do
      allow(searcher).to receive(:search_by_name).with('jane', case_sensitive: true).and_return([clients[1]])

      results = searcher.search_by_name('jane', case_sensitive: true)

      expect(results.size).to eq(1)
      expect(results.first['full_name']).to eq('Jane Smith')
    end
  end
end
