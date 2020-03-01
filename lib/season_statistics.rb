module SeasonStatistics

  def biggest_bust(season)
    # Name of the team with the biggest decrease between
    # regular season and postseason win percentage.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]

      x = winning_percentage(team, season, :regular)
      y = winning_percentage(team, season, :post)

      foo[team_name] = ( x - y ).abs.round(2)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def biggest_surprise(season)
    # Name of the team with the biggest increase between
    # regular season and postseason win percentage.
    foo = {}

    teams.each do |team|
      team_name = team["teamName"]

      x = winning_percentage(team, season, :regular)
      y = winning_percentage(team, season, :post)

      foo[team_name] = ( x + y ).abs.round(2)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def winningest_coach(season)
    # Name of the Coach with the best win percentage for the season
    season_game_ids = season_games(season).map { |game| game["game_id"] }

    season_game_teams = game_teams.select { |game|
      season_game_ids.include? game["game_id"]
    }

    foo = {}
    coaches.each do |coach|
      foo[coach] = []

      season_game_teams.each do |team|
        next if team["head_coach"] != coach

        game_data = {
          game_id: team['game_id'],
          result: team['result'],
        }

        foo[coach] << game_data
      end

      games_coached = foo[coach].size
      games_won = foo[coach].select { |game| game[:result] == "WIN" }.size
      winning_percentage =
        games_coached == 0 ? 0.0 : (games_won / games_coached.to_f).round(2)

      season_coaching_data = {
        games_coached: games_coached,
        games_won: games_won,
        winning_percentage: winning_percentage
      }

      foo[coach] = season_coaching_data
    end

    foo.sort_by { |k,v| -k }.sort_by { |k,v| -v[:winning_percentage] }.first[0]
  end

  def worst_coach(season)
    # Name of the Coach with the worst win percentage for the season
    season_game_ids = season_games(season).map { |game| game["game_id"] }

    season_game_teams = game_teams.select { |game|
      season_game_ids.include? game["game_id"]
    }

    foo = {}
    coaches.each do |coach|
      foo[coach] = []

      season_game_teams.each do |team|
        next if team["head_coach"] != coach

        game_data = {
          game_id: team['game_id'],
          result: team['result'],
        }

        foo[coach] << game_data
      end

      games_coached = foo[coach].size
      games_won = foo[coach].select { |game| game[:result] == "WIN" }.size
      winning_percentage =
        games_coached == 0 ? 0.0 : (games_won / games_coached.to_f).round(2)

      season_coaching_data = {
        games_coached: games_coached,
        games_won: games_won,
        winning_percentage: winning_percentage
      }

      foo[coach] = season_coaching_data
    end

    foo
      .select { |k, v| v[:games_coached] != 0 }
      .sort_by { |k,v| -k }.sort_by { |k,v| v[:winning_percentage] }.first[0]
  end

  def most_accurate_team(season)
    # Name of the Team with the best ratio of shots to goals for the season
    season_games = games.select { |game| game["season"] == season }
    season_game_ids = season_games.map { |game| game["game_id"] }

    season_game_teams = game_teams.select { |game|
      season_game_ids.include? game["game_id"]
    }

    foo = {}
    teams.each do |team|
      team_id = team["team_id"]
      team_name = team["teamName"]

      z = season_game_teams.select { |team| team["team_id"] == team_id }
      # add shots and goals..figure percent

      goals = z.reduce(0) { |sum, v| sum + v["goals"].to_i }
      shots = z.reduce(0) { |sum, v| sum + v["shots"].to_i }

      if shots == 0
        team_data = {
          shots_to_goals_ratio: 0.0
        }
      else
        team_data = {
          shots_to_goals_ratio: (goals / shots.to_f).round(2)
        }
      end

      foo[team_name] = team_data
    end


    foo
      .select { |k, v| v[:shots_to_goals_ratio] != 0.0 }
      .sort_by { |k,v| v[:shots_to_goals_ratio] }.last[0]
  end

  def least_accurate_team(season)
    # Name of the Team with the worst ratio of shots to goals for the season
    season_games = games.select { |game| game["season"] == season }
    season_game_ids = season_games.map { |game| game["game_id"] }

    season_game_teams = game_teams.select { |game|
      season_game_ids.include? game["game_id"]
    }

    foo = {}
    teams.each do |team|
      team_id = team["team_id"]
      team_name = team["teamName"]

      z = season_game_teams.select { |team| team["team_id"] == team_id }
      # add shots and goals..figure percent

      goals = z.reduce(0) { |sum, v| sum + v["goals"].to_i }
      shots = z.reduce(0) { |sum, v| sum + v["shots"].to_i }

      if shots == 0
        team_data = {
          shots_to_goals_ratio: 0.0
        }
      else
        team_data = {
          shots_to_goals_ratio: (goals / shots.to_f).round(2)
        }
      end

      foo[team_name] = team_data
    end

    foo.select { |k, v| v[:shots_to_goals_ratio] != 0.0 }
      .sort_by { |k, v| k }.sort_by { |k,v| v[:shots_to_goals_ratio] }.first[0]
  end

  def most_tackles(season)
    # Name of the Team with the most tackles in the season
    season_games = games.select { |game| game["season"] == season }
    season_game_ids = season_games.map { |game| game["game_id"] }

    season_game_teams = game_teams.select { |game|
      season_game_ids.include? game["game_id"]
    }

    foo = {}
    teams.each do |team|
      team_id = team["team_id"]
      team_name = team["teamName"]

      z = season_game_teams.select { |team| team["team_id"] == team_id }

      tackles = z.reduce(0) { |sum, v| sum + v["tackles"].to_i }

        team_data = {
          tackles: tackles
        }

      foo[team_name] = team_data
    end


    foo.select { |k, v| v[:tackles] != 0 }
      .sort_by { |k,v| v[:tackles] }
      .last[0]
  end

  def fewest_tackles(season)
    # Name of the Team with the fewest tackles in the season
    season_games = games.select { |game| game["season"] == season }
    season_game_ids = season_games.map { |game| game["game_id"] }

    season_game_teams = game_teams.select { |game|
      season_game_ids.include? game["game_id"]
    }

    foo = {}
    teams.each do |team|
      team_id = team["team_id"]
      team_name = team["teamName"]

      z = season_game_teams.select { |team| team["team_id"] == team_id }

      tackles = z.reduce(0) { |sum, v| sum + v["tackles"].to_i }

        team_data = {
          tackles: tackles
        }

      foo[team_name] = team_data
    end

    foo.select { |k, v| v[:tackles] != 0 }
      .sort_by { |k,v| v[:tackles] }
      .first[0]
  end


  private


  def season_games(season)
    games.select { |game| game["season"] == season }
  end

  def coaches
    game_teams.map { |team| team["head_coach"] }.uniq
  end

  def game_type(game, type)
    return true if type == :all
    return (game["type"] == "Regular Season") if type == :regular
    (game["type"] == "Postseason")
  end

  def winning_percentage(team, season, type)
    team_id = team["team_id"]

    away_games_played_this_season =
      games.select do |game|
        (game["away_team_id"] == team_id) &&
          (game["season"] == season) &&
          game_type(game, type)
      end

    home_games_played_this_season =
      games.select do |game|
        (game["home_team_id"] == team_id) &&
          (game["season"] == season) &&
          game_type(game, type)
      end

    away_games_won_this_season =
      away_games_played_this_season.select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end.size

      home_games_won_this_season =
        home_games_played_this_season.select do |game|
          game["home_goals"].to_f > game["away_goals"].to_f
        end.size

        games_played =
          home_games_played_this_season.size +
          away_games_played_this_season.size

        games_won =
          home_games_won_this_season +
          away_games_won_this_season

        winning_percent_this_season(games_played, games_won)
  end

  def winning_percent_this_season(games_played, games_won)
    return 0.0 if games_played == 0
    (games_won / games_played.to_f)
  end
end

