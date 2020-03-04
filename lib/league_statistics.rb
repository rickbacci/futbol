module LeagueStatistics

  def count_of_teams
    # Total number of teams in the data.
    teams.size
  end

  def best_offense
    # Name of the team with the highest average number
    # of goals scored per game across all seasons.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]
      foo[team_name] = average_goals_scored_per_game(team)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def worst_offense
    # Name of the team with the lowest average number
    # of goals scored per game across all seasons.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]
      foo[team_name] = average_goals_scored_per_game(team)
    end

    foo.sort_by { |k,v| -v }.last[0]
  end

  def best_defense
    # Name of the team with the lowest
    # average number of goals allowed per game across all seasons.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]
      foo[team_name] = average_goals_allowed_per_game(team)
    end

    foo.sort_by { |k,v| v }.first[0]
  end

  def worst_defense
    # Name of the team with the highest average number
    # of goals allowed per game across all seasons.

    foo = {}

    teams.each do |team|
      team_name = team["teamName"]
      foo[team_name] = average_goals_allowed_per_game(team)
    end

    foo.sort_by { |k,v| v }.last[0]
  end

  def highest_scoring_visitor
    # Name of the team with the highest average score per game
    # across all seasons when they are away.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]
      foo[team_name] = average_goals_away(team)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def highest_scoring_home_team
    # Name of the team with the highest average score per game
    # across all seasons when they are home.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]
      foo[team_name] = average_goals_home(team)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def lowest_scoring_visitor
    # Name of the team with the lowest average score per game
    # across all seasons when they are a visitor.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]
      foo[team_name] = average_goals_away(team)
    end

    foo.sort_by { |k,v| -v }.last[0]
  end

  def lowest_scoring_home_team
    # Name of the team with the lowest average score per game
    # across all seasons when they are at home.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]
      foo[team_name] = average_goals_home(team)
    end

    foo.sort_by { |k,v| -v }.last[0]
  end

  def winningest_team
    # Name of the team with the highest win percentage across all seasons.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]

      foo[team_name] = winning_percent(team)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def best_fans
    # Name of the team with biggest difference
    # between home and away win percentages.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]
      foo[team_name] = home_away_winning_percent_difference(team)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def worst_fans
    # List of names of all teams with
    # better away records than home records.
    foo = []

    teams.each do |team|
      team_name = team["teamName"]
      foo << team_name if better_away_record?(team)
    end

    foo
  end


  private


  def better_away_record?(team)
    total_away_games_won(team) > total_home_games_won(team)
  end

  def home_away_winning_percent_difference(team)
    (away_games_win_percentage(team) - home_games_win_percentage(team))
      .abs.round(2)
  end

  def away_games_win_percentage(team)
    total_away_games_won(team) / total_away_games_played(team)
  end

  def home_games_win_percentage(team)
    total_home_games_won(team) / total_home_games_played(team)
  end

  def away_games(team)
    games.select do |game|
      game["away_team_id"] == team["team_id"]
    end
  end

  def total_away_games_played(team)
    away_games(team).size.to_f
  end

  def home_games(team)
    games.select do |game|
      game["home_team_id"] == team["team_id"]
    end
  end

  def total_home_games_played(team)
    home_games(team).size.to_f
  end

  def average_goals_away(team)
    away_games(team).map do |game|
      game["away_goals"].to_i
    end.reduce(:+) / away_games(team).size.to_f
  end

  def average_goals_home(team)
    home_games(team).map do |game|
      game["home_goals"].to_i
    end.reduce(:+) / home_games(team).size.to_f
  end

  def total_away_games_won(team)
    away_games(team).select do |game|
      game["away_goals"].to_f > game["home_goals"].to_f
    end.size
  end

  def total_home_games_won(team)
    home_games(team).select do |game|
      game["home_goals"].to_f > game["away_goals"].to_f
    end.size
  end

  def average_goals_scored_per_game(team)
    average_goals_home(team) > average_goals_away(team) ?
      average_goals_home(team) : average_goals_away(team)
  end

  def total_games_won(team)
    total_home_games_won(team) + total_away_games_won(team)
  end

  def total_games_played(team)
    (away_games(team).size + home_games(team).size).to_f
  end

  def winning_percent(team)
    total_games_won(team) / total_games_played(team)
  end

  def average_opponent_goals_away(team)
    away_games(team).map do |game|
      game["home_goals"].to_f
    end.reduce(:+) / away_games(team).size
  end

  def average_opponent_goals_home(team)
    home_games(team).map do |game|
      game["away_goals"].to_f
    end.reduce(:+) / home_games(team).size
  end

  def average_goals_allowed_per_game(team)
    average_opponent_goals_home(team) > average_opponent_goals_away(team) ?
    average_opponent_goals_home(team).round(2) :
    average_opponent_goals_away(team).round(2)
  end

end
