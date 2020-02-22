module LeagueStatistics

  def count_of_teams
    teams.size
  end

  def best_offense
    # Name of the team with the highest average number of
    # goals scored per game across all seasons
    foo = {}

    teams.each do |team|

      away_games = games.select do |game|
        game["away_team_id"] == team["team_id"]
      end

      average_goals_away = away_games.map do |game|
        game["away_goals"].to_f
      end.reduce(:+) / away_games.size


      home_games = games.select do |game|
        game["home_team_id"] == team["team_id"]
      end

      average_goals_home = home_games.map do |game|
        game["home_goals"].to_f
      end.reduce(:+) / home_games.size

      highest_average = average_goals_home > average_goals_away ? average_goals_home.round(2) : average_goals_away.round(2)

      team_name = team["teamName"]

      foo[team_name] = highest_average
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def worst_offense
    # Name of the team with the lowest average number of
    # goals scored per game across all seasons
    foo = {}

    teams.each do |team|

      away_games = games.select do |game|
        game["away_team_id"] == team["team_id"]
      end

      average_goals_away = away_games.map do |game|
        game["away_goals"].to_f
      end.reduce(:+) / away_games.size


      home_games = games.select do |game|
        game["home_team_id"] == team["team_id"]
      end

      average_goals_home = home_games.map do |game|
        game["home_goals"].to_f
      end.reduce(:+) / home_games.size

      highest_average = average_goals_home > average_goals_away ? average_goals_home.round(2) : average_goals_away.round(2)

      team_name = team["teamName"]

      foo[team_name] = highest_average
    end

    foo.sort_by { |k,v| -v }.last[0]
  end

  def best_defense
    # Name of the team with the lowest average number of goals allowed
    # per game across all seasons.
    foo = {}

    teams.each do |team|

      away_games = games.select do |game|
        game["away_team_id"] == team["team_id"]
      end

      # track the other teams goals
      average_goals_away = away_games.map do |game|
        game["home_goals"].to_f
      end.reduce(:+) / away_games.size


      home_games = games.select do |game|
        game["home_team_id"] == team["team_id"]
      end

      # track the other teams goals
      average_goals_home = home_games.map do |game|
        game["away_goals"].to_f
      end.reduce(:+) / home_games.size

      highest_average = average_goals_home > average_goals_away ? average_goals_home.round(2) : average_goals_away.round(2)

      team_name = team["teamName"]

      foo[team_name] = highest_average
    end

    foo.sort_by { |k,v| -v }.last[0]
  end

  def worst_defense
    # Name of the team with the lowest average number of goals allowed
    # per game across all seasons.
    foo = {}

    teams.each do |team|

      away_games = games.select do |game|
        game["away_team_id"] == team["team_id"]
      end

      # track the other teams goals
      average_goals_away = away_games.map do |game|
        game["home_goals"].to_f
      end.reduce(:+) / away_games.size


      home_games = games.select do |game|
        game["home_team_id"] == team["team_id"]
      end

      # track the other teams goals
      average_goals_home = home_games.map do |game|
        game["away_goals"].to_f
      end.reduce(:+) / home_games.size

      highest_average = average_goals_home > average_goals_away ? average_goals_home.round(2) : average_goals_away.round(2)

      team_name = team["teamName"]

      foo[team_name] = highest_average
    end

    foo.sort_by { |k,v| v }.last[0]
  end

  def highest_scoring_visitor
    # Name of the team with the highest average score per game across all seasons when they are away.

    foo = {}

    teams.each do |team|

      away_games = games.select do |game|
        game["away_team_id"] == team["team_id"]
      end

      average_goals_away = away_games.map do |game|
        game["away_goals"].to_f
      end.reduce(:+) / away_games.size


      # home_games = games.select do |game|
      #   game["home_team_id"] == team["team_id"]
      # end

      # average_goals_home = home_games.map do |game|
      #   game["home_goals"].to_f
      # end.reduce(:+) / home_games.size

      # highest_average = average_goals_home > average_goals_away ? average_goals_home.round(2) : average_goals_away.round(2)

      team_name = team["teamName"]

      # foo[team_name] = highest_average
      foo[team_name] = average_goals_away.round(2)
    end

    foo.sort_by { |k,v| -v }.first[0]

  end

end
