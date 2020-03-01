module LeagueStatistics

  def count_of_teams
    teams.size
  end

  def best_offense
    foo = {}

    teams.each do |team|
      highest_average =
        average_goals_home(team) > average_goals_away(team) ?
        average_goals_home(team) : average_goals_away(team)

      team_name = team["teamName"]

      foo[team_name] = highest_average
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def worst_offense
    foo = {}

    teams.each do |team|
      highest_average =
        average_goals_home(team) > average_goals_away(team) ?
        average_goals_home(team).round(2) :
        average_goals_away(team)

      team_name = team["teamName"]

      foo[team_name] = highest_average
    end

    foo.sort_by { |k,v| -v }.last[0]
  end

  def best_defense
    foo = {}

    teams.each do |team|
      average_goals_away = away_games(team).map do |game|
        game["home_goals"].to_f
      end.reduce(:+) / away_games(team).size

      average_goals_home = home_games(team).map do |game|
        game["away_goals"].to_f
      end.reduce(:+) / home_games(team).size

      highest_average =
        average_goals_home > average_goals_away ?
        average_goals_home.round(2) :
        average_goals_away.round(2)

      team_name = team["teamName"]

      foo[team_name] = highest_average
    end

    foo.sort_by { |k,v| -v }.last[0]
  end

  def worst_defense
    foo = {}

    teams.each do |team|
      average_goals_away = away_games(team).map do |game|
        game["home_goals"].to_f
      end.reduce(:+) / away_games(team).size

      average_goals_home = home_games(team).map do |game|
        game["away_goals"].to_f
      end.reduce(:+) / home_games(team).size

      highest_average =
        average_goals_home > average_goals_away ?
        average_goals_home.round(2) :
        average_goals_away.round(2)

      team_name = team["teamName"]

      foo[team_name] = highest_average
    end

    foo.sort_by { |k,v| v }.last[0]
  end

  def highest_scoring_visitor
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]
      foo[team_name] = average_goals_away(team)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def highest_scoring_home_team
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]

      foo[team_name] = average_goals_home(team)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def lowest_scoring_visitor
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]

      foo[team_name] = average_goals_away(team)
    end

    foo.sort_by { |k,v| v }.first[0]
  end

  def lowest_scoring_home_team
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]

      foo[team_name] = average_goals_home(team)
    end

    foo.sort_by { |k,v| v }.first[0]
  end

  def winningest_team
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]

      home_games_won = home_games(team)
        .select { |game| game["home_goals"].to_f > game["away_goals"].to_f }.size

      total_games_won = home_games_won + away_games_won(team)
      total_games_played = away_games(team).size + home_games(team).size

      winning_percent = total_games_won / total_games_played.to_f

      foo[team_name] = winning_percent
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def best_fans
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]

      away_games_played = away_games(team).size
      away_games_win_percentage = away_games_won(team) / away_games_played.to_f

      home_games_won =
        home_games(team).select { |game| game["home_goals"].to_f > game["away_goals"].to_f }.size
      home_games_played = home_games(team).size
      home_games_win_percentage = home_games_won / home_games_played.to_f

      winning_percent_difference =
        (away_games_win_percentage - home_games_win_percentage).abs.round(2)

      foo[team_name] = winning_percent_difference
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def worst_fans
    foo = []

    teams.each do |team|
      team_name = team["teamName"]

      home_games_won = games.select do |game|
        (game["home_team_id"] == team["team_id"]) &&
          (game["home_goals"] > game["away_goals"])
      end.size

      foo << team_name if away_games_won(team) > home_games_won
    end

    foo
  end


  private


    def away_games(team)
      games.select do |game|
        game["away_team_id"] == team["team_id"]
      end
    end

    def home_games(team)
      games.select do |game|
        game["home_team_id"] == team["team_id"]
      end
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

    def away_games_won(team)
      away_games(team).select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end.size
    end
end
