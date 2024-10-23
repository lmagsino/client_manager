require 'rspec'
require_relative '../lib/duplicate_checker'
require_relative '../lib/indexer'

RSpec.describe DuplicateChecker do
  let(:clients) do
    [
      { "id" => 1, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" },
      { "id" => 2, "full_name" => "Another Jane Smith", "email" => "jane.smith@yahoo.com" }
    ]
  end

  let(:indexer) { instance_double(Indexer) }
  let(:checker) { DuplicateChecker.new(indexer) }

  before do
    allow(Indexer).to receive(:new).with(clients).and_return(indexer)
  end

  describe '#find_duplicates' do
    context 'when duplicates are found' do
      it 'returns clients with duplicate emails' do
        allow(indexer).to receive(:build_index).with('email', prefix_index: false).and_return({
          'jane.smith@yahoo.com' => clients
        })

        result = checker.find_duplicates('email')

        expect(result.keys).to include('jane.smith@yahoo.com')
        expect(result['jane.smith@yahoo.com'].size).to eq(2)
      end
    end

    context 'when no duplicates are found' do
      it 'returns an empty hash' do
        unique_clients = [
          { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
          { "id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" }
        ]
        allow(indexer).to receive(:build_index).with('email', prefix_index: false).and_return({
          'john.doe@gmail.com' => [unique_clients[0]],
          'jane.smith@yahoo.com' => [unique_clients[1]]
        })

        result = checker.find_duplicates('email')

        expect(result).to be_empty
      end
    end
  end
end
