# frozen_string_literal: true

require 'csv'

# comment
class Parser
  def self.parse(file)
    objects = []

    options = {
      headers: true
    }

    CSV.foreach(file, options) do |row|
      objects << row.to_hash
    end

    objects
  end
end
