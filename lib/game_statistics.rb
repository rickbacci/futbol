# frozen_string_literal: true

# whatever
module GameStatistics
  def highest_total_score
    games.map { |game| total_score(game) }.max
  end

  def lowest_total_score
    games.map { |game| total_score(game) }.min
  end

  def biggest_blowout
    games.map { |game| difference_in_score(game) }.max
  end

  def percentage_home_wins
    total_home_wins = 0
    games.each { |game| total_home_wins += 1 if home_wins(game) }

    (total_home_wins / total_games).round(2)
  end

  def percentage_visitor_wins
    total_visitor_wins = 0
    games.each { |game| total_visitor_wins += 1 if visitor_wins(game) }

    (total_visitor_wins / total_games).round(2)
  end

  def percentage_ties
    total_tie_games = 0
    games.each { |game| total_tie_games += 1 if tie(game) }

    (total_tie_games / total_games).round(2)
  end

  def count_of_games_by_season
    games = {}
    seasons.each { |season| games[season.to_s] = total_season_games(season) }

    games
  end

  def average_goals_per_game
    (total_goals_per_game / total_games).round(2)
  end

  def average_goals_by_season
    average_goals = {}
    seasons.each { |season| average_goals[season.to_s] = average_goals(season) }

    average_goals
  end

  private

  def seasons
    games.map { |game| game['season'] }.uniq.sort
  end

  def total_games
    games.length.to_f
  end

  def total_season_games(season)
    season_games(season).count.to_f
  end

  def visitor_wins(game)
    game['home_goals'].to_i < game['away_goals'].to_i
  end

  def home_wins(game)
    game['home_goals'].to_i > game['away_goals'].to_i
  end

  def tie(game)
    game['home_goals'].to_i == game['away_goals'].to_i
  end

  def total_score(game)
    game['away_goals'].to_i + game['home_goals'].to_i
  end

  def difference_in_score(game)
    (game['away_goals'].to_i - game['home_goals'].to_i).abs
  end

  def total_goals_per_game
    games.map { |game| total_score(game) }.reduce(:+)
  end

  def total_goals_per_season(season)
    season_games(season).map { |game| total_score(game) }.reduce(:+)
  end

  def average_goals(season)
    (total_goals_per_season(season) / total_season_games(season)).round(2)
  end
end
