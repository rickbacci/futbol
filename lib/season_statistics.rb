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


  private


  def game_type(game, type)
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

