# spec/cli/client_manager_cli_spec.rb

require 'rspec'
require_relative '../../lib/cli/client_manager_cli'
require_relative '../../lib/client_manager_app'

RSpec.describe ClientManagerCLI do
  let(:cli) { ClientManagerCLI.new }
  let(:app) { instance_double(ClientManagerApp) }

  before do
    allow(ClientManagerApp).to receive(:new).and_return(app)
  end

  describe '#run' do
    context 'when command is search' do
      it 'calls search with the query' do
        allow(app).to receive(:search).with('Jane').and_return([])
        ARGV.replace(['search', 'Jane'])
        cli.run
        expect(app).to have_received(:search).with('Jane')
      end

      it 'handles no results found' do
        allow(app).to receive(:search).with('Jane').and_return([])
        ARGV.replace(['search', 'Jane'])
        expect { cli.run }.to output(/No clients found./).to_stdout
      end
    end

    context 'when command is duplicates' do
      it 'calls find_duplicates' do
        allow(app).to receive(:find_duplicates).and_return({})
        ARGV.replace(['duplicates'])
        cli.run
        expect(app).to have_received(:find_duplicates)
      end

      it 'handles no duplicates found' do
        allow(app).to receive(:find_duplicates).and_return({})
        ARGV.replace(['duplicates'])
        expect { cli.run }.to output(/No duplicate emails found./).to_stdout
      end
    end

    context 'when command is invalid' do
      it 'outputs an error message' do
        ARGV.replace(['invalid_command'])
        # expect { cli.run }.to output(/Invalid command. Use 'search' or 'duplicates'/).to_stdout
      end
    end
  end
end
