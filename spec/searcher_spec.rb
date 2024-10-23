require 'rspec'
require_relative '../lib/searcher'
require_relative '../lib/indexer'

RSpec.describe Searcher do
  let(:clients) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@gmail.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@yahoo.com' },
      { 'id' => 3, 'full_name' => 'Another Jane Smith', 'email' => 'jane.smith@yahoo.com' }
    ]
  end

  let(:indexer) { instance_double(Indexer) }
  let(:searcher) { Searcher.new(indexer) }

  before do
    allow(Indexer).to receive(:new).with(clients).and_return(indexer)
  end

  describe '#search_by_field' do
    context 'when matching clients are found' do
      it 'returns clients that match the query' do
        allow(indexer).to receive(:build_index).with('full_name', prefix_index: true).and_return({
          'jane' => clients[1..2],
          'jane s' => clients[1..2],
          'jane sm' => clients[1..2],
          'jane smi' => clients[1..2],
          'jane smit' => clients[1..2],
          'jane smith' => clients[1..2]
        })

        results = searcher.search_by_field('full_name', 'Jane', case_sensitive: false)

        expect(results.size).to eq(2)
        expect(results.map { |client| client['full_name'] }).to include('Jane Smith', 'Another Jane Smith')
      end
    end

    context 'when no matching clients are found' do
      it 'returns an empty array' do
        allow(indexer).to receive(:build_index).with('full_name', prefix_index: true).and_return({})

        results = searcher.search_by_field('full_name', 'Nonexistent', case_sensitive: false)

        expect(results).to be_empty
      end
    end
  end

  describe '#search with case sensitivity' do
    it 'returns clients matching the case-sensitive query' do
      allow(indexer).to receive(:build_index).with('full_name', prefix_index: true).and_return({
        'Jane' => [clients[1]],
        'Jane S' => [clients[1]],
        'Jane Sm' => [clients[1]],
        'Jane Smi' => [clients[1]],
        'Jane Smit' => [clients[1]],
        'Jane Smith' => [clients[1]]
      })

      results = searcher.search_by_field('full_name', 'Jane', case_sensitive: true)

      expect(results.size).to eq(1)
      expect(results.first['full_name']).to eq('Jane Smith')
    end
  end
end
