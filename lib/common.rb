module Common

  def home_games_played(team_id, season = :all, type = :all)
    games.select do |game|
      (game["home_team_id"] == team_id) &&
        season_check(game, season) &&
        game_type(game, type)
    end
  end

  def away_games_played(team_id, season = :all, type = :all)
    games.select do |game|
      (game["away_team_id"] == team_id) &&
        season_check(game, season) &&
        game_type(game, type)
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

    away_games_won =
      away_games_played(team_id, season, type).select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end.size

      home_games_won =
        home_games_played(team_id, season, type).select do |game|
          game["home_goals"].to_f > game["away_goals"].to_f
        end.size

        games_played =
          home_games_played(team_id, season, type).size +
          away_games_played(team_id, season, type).size

        games_won =
          home_games_won +
          away_games_won

        winning_percent(games_played, games_won)
  end

  def winning_percent(games_played, games_won)
    return 0.0 if games_played == 0
    (games_won / games_played.to_f)
  end

  def game_type(game, type)
    case type
    when :regular
      (game["type"] == "Regular Season")
    when :post
      (game["type"] == "Postseason")
    else # :all
      true
    end
  end

  def season_check(game, season)
    return true if season == :all
    (game["season"] == season)
  end

end
