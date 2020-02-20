require 'csv'

class Parser
  def self.parse(file)
    objects = []

    options = {
      headers: true,
      header_converters: :symbol
    }

    CSV.foreach(file, options) do |row|
      objects << row.to_hash
    end

    objects
  end
end
