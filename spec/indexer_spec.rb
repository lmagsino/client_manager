require 'rspec'
require_relative '../lib/indexer'

RSpec.describe Indexer do
  let(:clients) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@example.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@example.com' },
      { 'id' => 3, 'full_name' => 'John Smith', 'email' => 'john.smith@example.com' }
    ]
  end

  let(:indexer) { Indexer.new(clients) }

  describe '#build_index' do
    it 'returns the same index for subsequent calls with the same parameters' do
      first_call = indexer.build_index('full_name', prefix_index: true)
      second_call = indexer.build_index('full_name', prefix_index: true)

      expect(first_call.object_id).to eq(second_call.object_id)
    end

    it 'returns the same index regardless of prefix_index value' do
      prefix_index = indexer.build_index('full_name', prefix_index: true)
      non_prefix_index = indexer.build_index('full_name', prefix_index: false)

      expect(prefix_index.object_id).to eq(non_prefix_index.object_id)
    end

    it 'builds an index with prefixes when prefix_index is true' do
      index = indexer.build_index('full_name', prefix_index: true)

      expect(index.keys).to include('j', 'jo', 'joh', 'john', 'john d', 'john do', 'john doe')
      expect(index['john']).to contain_exactly(clients[0], clients[2])
      expect(index['jane']).to contain_exactly(clients[1])
    end

    it 'builds an index without prefixes when prefix_index is false' do
      index = indexer.build_index('full_name', prefix_index: false)

      expect(index.keys).to contain_exactly('john doe', 'jane smith', 'john smith')
      expect(index['john doe']).to contain_exactly(clients[0])
      expect(index['jane smith']).to contain_exactly(clients[1])
      expect(index['john smith']).to contain_exactly(clients[2])
    end

    it 'builds separate indices for different fields' do
      name_index = indexer.build_index('full_name', prefix_index: false)
      email_index = indexer.build_index('email', prefix_index: false)

      expect(name_index.object_id).not_to eq(email_index.object_id)
      expect(name_index.keys).to contain_exactly('john doe', 'jane smith', 'john smith')
      expect(email_index.keys).to contain_exactly(
        'john.doe@example.com', 'jane.smith@example.com', 'john.smith@example.com'
      )
    end
  end
end
