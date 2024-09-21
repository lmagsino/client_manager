require_relative '../lib/json_loader'

RSpec.describe JSONLoader do
  it 'loads clients from a valid JSON file' do
    clients = JSONLoader.load('clients.json')
    expect(clients).to be_an(Array)
    expect(clients.first).to have_key('full_name')
  end

  it 'returns an empty array if the file is not found' do
    clients = JSONLoader.load('non_existent_file.json')
    expect(clients).to eq([])
  end
end
