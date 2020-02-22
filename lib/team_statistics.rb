module TeamStatistics


  def team_info(team_id)
    # A hash with key/value pairs for the following attributes:
    # team_id, franchise_id, team_name, abbreviation, and link
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

  def best_season(team_id)
    # Season with the highest win percentage for a team.
    # returns a String i.e. "20132014"
    foo = {}

    seasons.each do |season|
      away_games_played_this_season = games.select do |game|
        (game["away_team_id"] == team_id) && (game["season"] == season)
      end

      home_games_played_this_season = games.select do |game|
        (game["home_team_id"] == team_id) && (game["season"] == season)
      end

      away_games_won_this_season = away_games_played_this_season.select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end.size

      home_games_won_this_season = home_games_played_this_season.select do |game|
        game["home_goals"].to_f > game["away_goals"].to_f
      end.size

      total_games_played_this_season =
        home_games_played_this_season.size + away_games_played_this_season.size

      total_games_won_this_season =
        home_games_won_this_season + away_games_won_this_season

      winning_percent_this_season =
        total_games_won_this_season / total_games_played_this_season.to_f

      foo[season] = winning_percent_this_season
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def worst_season(team_id)
    # Season with the lowest win percentage for a team.
    # returns a String i.e. "20132014"
    foo = {}

    seasons.each do |season|
      away_games_played_this_season = games.select do |game|
        (game["away_team_id"] == team_id) && (game["season"] == season)
      end

      home_games_played_this_season = games.select do |game|
        (game["home_team_id"] == team_id) && (game["season"] == season)
      end

      away_games_won_this_season = away_games_played_this_season.select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end.size

      home_games_won_this_season = home_games_played_this_season.select do |game|
        game["home_goals"].to_f > game["away_goals"].to_f
      end.size

      total_games_played_this_season =
        home_games_played_this_season.size + away_games_played_this_season.size

      total_games_won_this_season =
        home_games_won_this_season + away_games_won_this_season

      winning_percent_this_season =
        total_games_won_this_season / total_games_played_this_season.to_f

      foo[season] = winning_percent_this_season
    end

    foo.sort_by { |k,v| v }.first[0]
  end

  def average_win_percentage(team_id)
    # Average win percentage of all games for a team.
    # returns a Float

    away_games_played = games.select do |game|
      (game["away_team_id"] == team_id)
    end

    home_games_played = games.select do |game|
      (game["home_team_id"] == team_id)
    end

    away_games_won = away_games_played.select do |game|
      game["away_goals"].to_f > game["home_goals"].to_f
    end.size

    home_games_won = home_games_played.select do |game|
      game["home_goals"].to_f > game["away_goals"].to_f
    end.size

    total_games_played =
      home_games_played.size + away_games_played.size

    total_games_won =
      home_games_won + away_games_won

    (total_games_won / total_games_played.to_f).round(2)
  end

  private


  def seasons
    games.map { |game| game["season"] }.uniq.sort
  end

end
