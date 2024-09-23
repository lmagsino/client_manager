# ClientManager - Command-Line Application

## Overview

ClientManager is a minimalist command-line application built in Ruby to manage client data from a JSON dataset. It allows you to:
- Search clients by partial or full name.
- Identify duplicate clients by checking for duplicate email addresses.

This is a simple and extendable CLI application, with a design that follows best practices such as modularity, separation of concerns, and unit testing.


## Project Structure
```
client_manager/
├── bin/
│   └── client_manager.rb      # Entry point for CLI
├── lib/
│   ├── json_loader.rb         # Handles loading the JSON data
│   ├── searcher.rb            # Contains search logic
│   ├── duplicate_checker.rb   # Checks for duplicates
│   └── client_manager_app.rb  # Generic interface layer (shared logic)
│   └── cli/
│       └── client_manager_cli.rb  # CLI-specific logic
├── spec/
│   ├── client_manager_cli_spec.rb  # Unit tests for CLI logic
│   ├── searcher_spec.rb       # Unit tests for search logic
│   ├── duplicate_spec.rb      # Unit tests for duplicate checker
│   ├── json_loader_spec.rb    # Unit tests for JSON loader
├── clients.json               # The dataset
├── Gemfile                    # Dependencies like RSpec or others
└── README.md                  # Instructions for setup and usage
```

## Setup and Installation

1. Clone the repository: `git clone https://github.com/lmagsino/client_manager.git`
2. Navigate into the project directory: `cd client_manager`
3. Make sure the Ruby version is `3.2.2`
4. Install dependencies: `bundle install`

## Usage
Run the application using the following commands:
1. **Search clients by name**:
      `ruby bin/client_manager.rb search "John"`
2. **Find duplicate emails**:
      `ruby bin/client_manager.rb duplicates`

## Unit Test
1. Install RSpec (if not installed):
      `gem install rspec`
2. Run tests:
      `rspec`

## Assumptions
1. **Data Structure**: The dataset is provided as a JSON file, with each client having the attributes `id`, `full_name`, and `email`.
2. **Command-line Arguments**: 
   - The `search` command searches clients by their `full_name`.
   - The `duplicates` command checks for duplicate emails.
3. **Case Sensitivity**: Searches for clients are **not** case-sensitive.
4. **File Input**: The application expects the `clients.json` file to be present in the root directory. If the file is missing, it handles the error gracefully.
5. **Scalability**: For now, this app loads all client data into memory, which is manageable for small datasets but not scalable for large ones (future extensions could involve database integration).


