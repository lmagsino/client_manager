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
      it 'calls search with the full_name field and query' do
        allow(app).to receive(:search).with('full_name', 'Jane').and_return([])
        ARGV.replace(['search', 'Jane'])
        cli.run
        expect(app).to have_received(:search).with('full_name', 'Jane')
      end

      it 'handles no results found' do
        allow(app).to receive(:search).with('full_name', 'Jane').and_return([])
        ARGV.replace(['search', 'Jane'])
        expect { cli.run }.to output(/No clients found./).to_stdout
      end

      it 'displays an error message when search term is missing' do
        ARGV.replace(['search'])
        expect { cli.run }.to output(/Please provide a valid search term./).to_stdout
      end
    end

    context 'when command is duplicates' do
      it 'calls find_duplicates with the email field' do
        allow(app).to receive(:find_duplicates).with('email').and_return([])
        ARGV.replace(['duplicates'])
        cli.run
        expect(app).to have_received(:find_duplicates).with('email')
      end

      it 'handles no duplicates found' do
        allow(app).to receive(:find_duplicates).with('email').and_return([])
        ARGV.replace(['duplicates'])
        expect { cli.run }.to output(/No duplicate emails found./).to_stdout
      end
    end

    context 'when command is invalid' do
      it 'outputs an error message with available commands' do
        ARGV.replace(['invalid_command'])
        expect { cli.run }.to output(/Invalid command. Available commands: search, duplicates/).to_stdout
      end
    end
  end

  describe '#display_search_results' do
    it 'displays search results correctly' do
      results = [
        { 'full_name' => 'John Doe', 'email' => 'john@example.com' },
        { 'full_name' => 'Jane Doe', 'email' => 'jane@example.com' }
      ]
      expected_output = "Clients found:\nJohn Doe (john@example.com)\nJane Doe (jane@example.com)\n"
      expect { cli.send(:display_search_results, results) }.to output(expected_output).to_stdout
    end
  end

  describe '#display_duplicates' do
    it 'displays duplicate results correctly' do
      duplicates = {
        'john@example.com' => [
          { 'full_name' => 'John Doe', 'email' => 'john@example.com' },
          { 'full_name' => 'Johnny Doe', 'email' => 'john@example.com' }
        ]
      }
      expected_output = "Duplicate emails found:\njohn@example.com:\n  - John Doe (john@example.com)\n  - Johnny Doe (john@example.com)\n"
      expect { cli.send(:display_duplicates, duplicates) }.to output(expected_output).to_stdout
    end

    it 'handles nil duplicates' do
      expect { cli.send(:display_duplicates, nil) }.not_to output.to_stdout
    end

    it 'handles empty duplicates' do
      expect { cli.send(:display_duplicates, {}) }.to output("No duplicate emails found.\n").to_stdout
    end
  end
end
