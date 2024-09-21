require 'json'

class JSONLoader
  def self.load(file_path)
    file = File.read(file_path)
    JSON.parse(file)
  rescue Errno::ENOENT
    puts "File not found: #{file_path}"
    []
  rescue JSON::ParserError => e
    puts "Error parsing JSON: #{e.message}"
    []
  end
end
