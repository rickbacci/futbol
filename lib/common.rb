module Common

  def home_games_played(team_id)
    games.select do |game|
      game["home_team_id"] == team_id
    end
  end

  def away_games_played(team_id)
    games.select do |game|
      game["away_team_id"] == team_id
    end
  end

  def total_games_played(team_id)
    (away_games_played(team_id).size +
     home_games_played(team_id).size).to_f
  end

  def total_home_games_won(team_id)
    home_games_played(team_id).select do |game|
      game["home_goals"].to_f > game["away_goals"].to_f
    end.size
  end

  def total_away_games_won(team_id)
    away_games_played(team_id).select do |game|
      game["away_goals"].to_f > game["home_goals"].to_f
    end.size
  end

  def total_games_won(team_id)
    total_home_games_won(team_id) +
      total_away_games_won(team_id)
  end

  def winning_percentage(team_id, season = :all, type = :all)

    away_games_played_this_season =
      games.select do |game|
        (game["away_team_id"] == team_id) &&
          season_check(game, season) &&
          game_type(game, type)
      end

    home_games_played_this_season =
      games.select do |game|
        (game["home_team_id"] == team_id) &&
          season_check(game, season) &&
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

        winning_percent(games_played, games_won)
  end

  def winning_percent(games_played, games_won)
    return 0.0 if games_played == 0
    (games_won / games_played.to_f)
  end

  def game_type(game, type)
    return true if type == :all
    return (game["type"] == "Regular Season") if type == :regular
    (game["type"] == "Postseason")
  end

  def season_check(game, season)
    return true if season == :all
    (game["season"] == season)
  end

end

