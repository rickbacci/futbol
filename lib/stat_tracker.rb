require_relative './parser'

class StatTracker
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

  def count_of_teams
    teams.size
  end

  def team_info(team_id)
    teams.each do |team|
      if team["team_id"] == team_id
        return {
          "abbreviation"=>team["abbreviation"],
          "franchise_id"=>team["franchiseId"],
          "link"=>team["link"],
          "team_id"=>team["team_id"],
          "team_name"=>team["teamName"]
        }
      end
    end
  end

  def highest_total_score
    total_goals = games.map do |game|
      game["away_goals"].to_i + game["home_goals"].to_i
    end
    total_goals.sort.last
  end

  def lowest_total_score
    total_goals = games.map do |game|
      game["away_goals"].to_i + game["home_goals"].to_i
    end
    total_goals.sort.first
  end

  def biggest_blowout
    difference_in_score = games.map do |game|
      (game["away_goals"].to_i - game["home_goals"].to_i).abs
    end
    difference_in_score.sort.last
  end


end
