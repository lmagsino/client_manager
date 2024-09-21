require_relative '../lib/duplicate_checker'

RSpec.describe DuplicateChecker do
  let(:clients) do
    [
      { "id" => 1, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" },
      { "id" => 2, "full_name" => "Another Jane Smith", "email" => "jane.smith@yahoo.com" }
    ]
  end

  it 'finds clients with duplicate emails' do
    checker = DuplicateChecker.new(clients)
    result = checker.find_duplicates
    expect(result.keys).to include('jane.smith@yahoo.com')
    expect(result['jane.smith@yahoo.com'].size).to eq(2)
  end

  it 'returns an empty hash when no duplicates are found' do
    clients = [
      { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
      { "id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" }
    ]
    checker = DuplicateChecker.new(clients)
    result = checker.find_duplicates
    expect(result).to be_empty
  end
end
