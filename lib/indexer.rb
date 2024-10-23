class Indexer
  def initialize(clients)
    @clients = clients
    @indices = {}
  end

  def build_index(field, prefix_index: false)
    return @indices[field] if @indices.key?(field)

    index = Hash.new { |hash, key| hash[key] = [] }
    @clients.each do |client|
      value = client[field]&.downcase
      if value
        index[value] << client
        if prefix_index
          # Add prefix indexing for search functionality
          value.chars.each_with_index do |_, i|
            prefix = value[0..i]
            index[prefix] << client unless index[prefix].include?(client)
          end
        end
      end
    end
    @indices[field] = index
  end
end
