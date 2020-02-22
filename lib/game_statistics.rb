module GameStatistics

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

  def percentage_home_wins
    total_games = games.length
    total_home_wins = 0.0

    games.each do |game|
      total_home_wins += 1 if game["home_goals"].to_i > game["away_goals"].to_i
    end

    (total_home_wins / total_games).round(2)
  end

  def percentage_visitor_wins
    total_games = games.length
    total_visitor_wins = 0.0

    games.each do |game|
      total_visitor_wins += 1 if game["home_goals"].to_i < game["away_goals"].to_i
    end

    (total_visitor_wins / total_games).round(2)
  end

  def percentage_ties
    total_games = games.length
    total_tie_games = 0.0

    games.each do |game|
      total_tie_games += 1 if game["home_goals"].to_i == game["away_goals"].to_i
    end

    (total_tie_games / total_games).round(2)
  end

  def count_of_games_by_season
    seasons = games.map { |game| game["season"] }.uniq.sort
    games_by_season = {}

    seasons.map do |season|
      total_games = games.select { |game| game["season"] == season }.count
      games_by_season["#{season}"] = total_games
    end

    games_by_season
  end

  def average_goals_per_game
    total_games = games.count
    total_goals_per_game = games.map do |game|
      game["away_goals"].to_f + game["home_goals"].to_f
    end

    total_goals = total_goals_per_game.reduce(:+)
    (total_goals / total_games).round(2)
  end

  def average_goals_by_season
    seasons = games.map { |game| game["season"] }.uniq
    average_goals_by_season = {}

    seasons.map do |season|
      season_games = games.select { |game| game["season"] == season }
      total_season_games = season_games.count

      total_goals_per_season = season_games.map do |game|
        game["away_goals"].to_f + game["home_goals"].to_f
      end
      total_goals = total_goals_per_season.reduce(:+)

      average_goals = total_goals / total_season_games

      average_goals_by_season["#{season}"] = average_goals.round(2)
    end

    average_goals_by_season
  end

end
