# frozen_string_literal: true

require_relative './parser'
require_relative './game_statistics'
require_relative './team_statistics'
require_relative './league_statistics'
require_relative './season_statistics'
require_relative './common'

# comment
class StatTracker
  include GameStatistics
  include TeamStatistics
  include LeagueStatistics
  include SeasonStatistics
  include Common

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

    new(@teams, @games, @game_teams)
  end
end
