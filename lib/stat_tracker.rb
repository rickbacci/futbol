require_relative './parser'
require_relative './game_statistics'
require_relative './team_statistics'
require_relative './league_statistics'

class StatTracker
  include GameStatistics
  include TeamStatistics
  include LeagueStatistics

  attr_reader :teams, :games, :game_teams

  def initialize(teams, games, game_teams)
    @teams = teams
    @games = games
    @game_teams = game_teams
  end

  def self.from_csv(locations)
    locations.each do |key, location|
      instance_variable_set("@#{key}", Parser.parse(location))
    end

    self.new(@teams, @games, @game_teams)
  end

end
