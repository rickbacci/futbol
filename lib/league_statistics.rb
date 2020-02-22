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

  def highest_scoring_home_team
    # Name of the team with the highest average score per game across all seasons when they are home.
    foo = {}

    teams.each do |team|

      # away_games = games.select do |game|
      #   game["away_team_id"] == team["team_id"]
      # end

      # average_goals_away = away_games.map do |game|
      #   game["away_goals"].to_f
      # end.reduce(:+) / away_games.size


      home_games = games.select do |game|
        game["home_team_id"] == team["team_id"]
      end

      average_goals_home = home_games.map do |game|
        game["home_goals"].to_f
      end.reduce(:+) / home_games.size

      # highest_average = average_goals_home > average_goals_away ? average_goals_home.round(2) : average_goals_away.round(2)

      team_name = team["teamName"]

      # foo[team_name] = highest_average
      foo[team_name] = average_goals_home.round(2)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def lowest_scoring_visitor
    # Name of the team with the lowest average score per game across all seasons when they are a visitor.
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

    foo.sort_by { |k,v| v }.first[0]

  end

  def lowest_scoring_home_team
    # Name of the team with the lowest average score per game across all
    # seasons when they are at home.
    foo = {}

    teams.each do |team|

      # away_games = games.select do |game|
      #   game["away_team_id"] == team["team_id"]
      # end

      # average_goals_away = away_games.map do |game|
      #   game["away_goals"].to_f
      # end.reduce(:+) / away_games.size


      home_games = games.select do |game|
        game["home_team_id"] == team["team_id"]
      end

      average_goals_home = home_games.map do |game|
        game["home_goals"].to_f
      end.reduce(:+) / home_games.size

      # highest_average = average_goals_home > average_goals_away ? average_goals_home.round(2) : average_goals_away.round(2)

      team_name = team["teamName"]

      # foo[team_name] = highest_average
      foo[team_name] = average_goals_home.round(2)
    end

    foo.sort_by { |k,v| v }.first[0]
  end

  # Name of the team with the highest win percentage
  # across all seasons.
  def winningest_team
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]

      away_games = games.select do |game|
        game["away_team_id"] == team["team_id"]
      end
      # 232

      # away_games = games.select do |game|
      #   game_teams_stats = game_teams.select do |game_team|
      #     game_team["game_id"] == game["game_id"]
      #   end

      #   if game_teams_stats.first["team_id"] == team["team_id"]
      #     true
      #   else
      #     false
      #   end
      # end
      # 232


      away_games_won = away_games.select { |game| game["away_goals"].to_f > game["home_goals"].to_f }.size
      # 76

      # away_games_won = away_games.select do |game|
      #   # find matching game_team_stats
      #   stats = game_teams.select do |game_team|
      #     game_team["game_id"] == game["game_id"]
      #   end

      #   if stats.first["team_id"] == team["team_id"] && stats.first["result"] == 'WIN'
      #     true
      #   else
      #     false
      #   end
      # end.size
      # 76

      home_games = games.select do |game|
        game["home_team_id"] == team["team_id"]
      end

      home_games_won = home_games.select { |game| game["home_goals"].to_f > game["away_goals"].to_f }.size

      total_games_won = home_games_won + away_games_won
      total_games_played = away_games.size + home_games.size

      winning_percent = total_games_won / total_games_played.to_f

      foo[team_name] = winning_percent
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  # Name of the team with biggest difference between home and away win
  # percentages.
  def best_fans
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]

      away_games = games.select do |game|
        game["away_team_id"] == team["team_id"]
      end

      home_games = games.select do |game|
        game["home_team_id"] == team["team_id"]
      end

      away_games_won = away_games.select { |game| game["away_goals"].to_f > game["home_goals"].to_f }.size
      away_games_played = away_games.size
      away_games_win_percentage = away_games_won / away_games_played.to_f

      home_games_won = home_games.select { |game| game["home_goals"].to_f > game["away_goals"].to_f }.size
      home_games_played = home_games.size
      home_games_win_percentage = home_games_won / home_games_played.to_f

      winning_percent_difference = (away_games_win_percentage - home_games_win_percentage).abs.round(2)

      foo[team_name] = winning_percent_difference
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  # List of names of all teams with better away records than home records.
  def worst_fans
    foo = []
    teams.each do |team|
      team_name = team["teamName"]

      away_games_won = games.select do |game|
        (game["away_team_id"] == team["team_id"]) &&
          (game["away_goals"] > game["home_goals"])
      end.size

      home_games_won = games.select do |game|
        (game["home_team_id"] == team["team_id"]) &&
          (game["home_goals"] > game["away_goals"])
      end.size

      foo << team_name if away_games_won > home_games_won
    end

    foo
  end
end
