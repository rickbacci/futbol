require 'csv'

class StatTracker
  attr_reader :teams, :games, :game_teams

  def initialize(teams, games, game_teams)
    @teams = teams
    @games = games
    @game_teams = game_teams
  end

  def self.from_csv(locations)
    teams = []
    games = []
    game_teams = []

    options = { headers: true, header_converters: :symbol }

    CSV.foreach(locations[:teams], options) do |row|
      teams << row.to_hash
    end

    CSV.foreach(locations[:games], options) do |row|
      games << row.to_hash
    end

    CSV.foreach(locations[:game_teams], options) do |row|
      game_teams << row.to_hash
    end

    self.new(teams, games, game_teams)
  end
end
