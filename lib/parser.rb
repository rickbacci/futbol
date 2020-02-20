require 'csv'

class Parser
  def self.parse(file)
    if File.exist?(file)

      objects = []

      options = {
        headers: true,
        header_converters: :symbol
      }

      CSV.foreach(file, options) do |row|
        objects << row.to_hash
      end

      objects
    else
      return "file not found!"
    end
  end
end
