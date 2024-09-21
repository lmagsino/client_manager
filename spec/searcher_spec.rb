require_relative '../lib/searcher'

RSpec.describe Searcher do
  let(:clients) do
    [
      { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
      { "id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" }
    ]
  end

  it 'finds clients by partial name match' do
    searcher = Searcher.new(clients)
    result = searcher.search_by_name("John")
    expect(result).to eq([{ "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" }])
  end
end
