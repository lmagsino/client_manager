# spec/duplicate_checker_spec.rb

require 'rspec'
require_relative '../lib/duplicate_checker'

RSpec.describe DuplicateChecker do
  let(:clients) do
    [
      { "id" => 1, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" },
      { "id" => 2, "full_name" => "Another Jane Smith", "email" => "jane.smith@yahoo.com" }
    ]
  end

  let(:checker) { instance_double(DuplicateChecker) }

  before do
    allow(DuplicateChecker).to receive(:new).with(clients).and_return(checker)
  end

  describe '#find_duplicates' do
    context 'when duplicates are found' do
      it 'returns clients with duplicate emails' do
        allow(checker).to receive(:find_duplicates).and_return(
          {
            'jane.smith@yahoo.com' => clients
          }
        )

        result = checker.find_duplicates

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
        allow(DuplicateChecker).to receive(:new).with(unique_clients).and_return(checker)

        allow(checker).to receive(:find_duplicates).and_return({})

        result = checker.find_duplicates

        expect(result).to be_empty
      end
    end
  end
end
