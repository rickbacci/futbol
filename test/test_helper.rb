require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end

require 'csv'
require 'pry'

require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require './lib/stat_tracker'
