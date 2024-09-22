# spec/json_loader_spec.rb

require 'rspec'
require_relative '../lib/json_loader'

RSpec.describe JSONLoader do
  let(:file_path) { 'clients.json' }
  let(:invalid_file_path) { 'non_existent_file.json' }
  let(:json_data) { '[{"full_name": "John Doe", "email": "john.doe@gmail.com"}]' }

  before do
    allow(File).to receive(:read).with(file_path).and_return(json_data)
  end

  describe '.load' do
    context 'when loading from a valid JSON file' do
      it 'returns an array of clients' do
        clients = JSONLoader.load(file_path)
        expect(clients).to be_an(Array)
        expect(clients.first).to have_key('full_name')
      end
    end

    context 'when the file is not found' do
      it 'returns an empty array' do
        allow(File).to receive(:read).with(invalid_file_path).and_raise(Errno::ENOENT)

        clients = JSONLoader.load(invalid_file_path)
        expect(clients).to eq([])
      end
    end

    context 'when the JSON is invalid' do
      it 'returns an empty array and prints an error message' do
        allow(File).to receive(:read).with(file_path).and_return('invalid json')

        expect { JSONLoader.load(file_path) }.to output(/Error parsing JSON:/).to_stdout
        clients = JSONLoader.load(file_path)
        expect(clients).to eq([])
      end
    end
  end
end
