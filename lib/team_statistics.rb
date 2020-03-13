# frozen_string_literal: true

# comment
module TeamStatistics
  # A hash with key/value pairs for the following attributes:
  # team_id, franchise_id, team_name, abbreviation, and link
  #
  def team_info(team_id)
    team = teams.find { |t| t['team_id'] == team_id }
    {
      'abbreviation' => team['abbreviation'],
      'franchise_id' => team['franchiseId'],
      'link' => team['link'],
      'team_id' => team['team_id'],
      'team_name' => team['teamName']
    }
  end

  # Season with the highest win percentage for a team.
  #
  def best_season(team_id)
    foo = {}

    seasons.each do |season|
      foo[season] = winning_percentage(team_id, season)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  # Season with the lowest win percentage for a team.
  #
  def worst_season(team_id)
    foo = {}

    seasons.each do |season|
      foo[season] = winning_percentage(team_id, season)
    end

    foo.max_by { |_k, v| -v }[0]
  end

  # Average win percentage of all games for a team.
  #
  def average_win_percentage(team_id)
    (total_games_won(team_id) / total_games_played(team_id)).round(2)
  end

  # Highest number of goals a particular team has scored in a single game.
  #
  def most_goals_scored(team_id)
    (away_goals_scored(team_id) + home_goals_scored(team_id)).max
  end

  # Lowest numer of goals a particular team has scored in a single game.
  #
  def fewest_goals_scored(team_id)
    (away_goals_scored(team_id) + home_goals_scored(team_id)).min
  end

  # Name of the opponent that has the lowest win percentage
  # against the given team.
  #
  def favorite_opponent(team_id)
    foo = {}

    opponents(team_id).each do |opponent|
      opponent_name = opponent['teamName']
      foo[opponent_name] = winning_percent_by_opponent(team_id, opponent)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  # Name of the opponent that has the highest
  # win percentage against the given team.
  #
  def rival(team_id)
    foo = {}

    opponents(team_id).each do |opponent|
      opponent_name = opponent['teamName']
      foo[opponent_name] = winning_percent_by_opponent(team_id, opponent)
    end

    foo.min_by { |_k, v| v }[0]
  end

  # Biggest difference between team goals and
  # opponent goals for a win for the given team.
  #
  def biggest_team_blowout(team_id)
    foo = {}

    opponents(team_id).each do |opponent|
      opponent_name = opponent['teamName']

      foo[opponent_name] = game_score_difference(team_id, opponent, :win)
    end

    foo.min_by { |_k, v| -v }[1]
  end

  # Biggest difference between team goals and opponent
  # goals for a loss for the given team.
  #
  def worst_loss(team_id)
    foo = {}

    opponents(team_id).each do |opponent|
      opponent_name = opponent['teamName']

      foo[opponent_name] =
        game_score_difference(team_id, opponent, :loss) || 0
    end

    foo.min_by { |_k, v| -v }[1]
  end

  # Record (as a hash - win/loss) against all opponents
  # with the opponents' names as keys and the win
  # percentage against that opponent as a value.
  #
  def head_to_head(team_id)
    foo = {}

    opponents(team_id).each do |opponent|
      opponent_name = opponent['teamName']
      foo[opponent_name] = winning_percent_by_opponent(team_id, opponent)
    end

    foo
  end

  # For each season that the team has played, a hash that has two keys
  # (:regular_season and :postseason), that each point to a hash with the
  # following keys: :win_percentage, :total_goals_scored, :total_goals_against,
  # :average_goals_scored, :average_goals_against.
  def seasonal_summary(team_id)
    summary = {}

    seasons.sort.each do |season|
      summary[season] = {
        postseason: season_stats(team_id, season, :post),
        regular_season: season_stats(team_id, season, :regular)
      }
    end

    summary
  end

  private

  def opponents(team_id)
    teams.reject { |team| team['team_id'] == team_id }
  end

  def season_stats(team_id, season, type)
    {
      win_percentage: winning_percentage(team_id, season, type),
      total_goals_scored: total_goals_scored(team_id, season, type),
      total_goals_against: total_goals_against(team_id, season, type),
      average_goals_scored: average_goals_scored(team_id, season, type),
      average_goals_against: average_goals_against(team_id, season, type)
    }
  end

  def game_score_difference(team_id, opponent, result)
    case result
    when :win
      (away_games_score_difference_for_win(team_id, opponent) +
      home_games_score_difference_for_win(team_id, opponent)).first
    when :loss
      (away_games_score_difference_for_loss(team_id, opponent) +
      home_games_score_difference_for_loss(team_id, opponent)).max
    end
  end

  def home_games_score_difference_for_loss(team_id, opponent)
    home_games_lost_by_opponent(team_id, opponent).map do |game|
      goal_difference(game)
    end
  end

  def home_games_score_difference_for_win(team_id, opponent)
    home_games_won_by_opponent(team_id, opponent).map do |game|
      goal_difference(game)
    end
  end

  def away_games_score_difference_for_loss(team_id, opponent)
    away_games_lost_by_opponent(team_id, opponent).map do |game|
      goal_difference(game)
    end
  end

  def away_games_score_difference_for_win(team_id, opponent)
    away_games_won_by_opponent(team_id, opponent).map do |game|
      goal_difference(game)
    end
  end

  def goal_difference(game)
    (game['away_goals'].to_i - game['home_goals'].to_i).abs
  end

  def seasons
    games.map { |game| game['season'] }.uniq.sort
  end

  def average_goals_against(team_id, season = :all, type = :all)
    goals_against =
      away_goals_against(team_id, season, type) +
      home_goals_against(team_id, season, type)

    return 0.0 if goals_against.empty?

    (goals_against.reduce(:+) / goals_against.size.to_f).round(2)
  end

  def average_goals_scored(team_id, season = :all, type = :all)
    goals_scored =
      away_goals_scored(team_id, season, type) +
      home_goals_scored(team_id, season, type)

    return 0.0 if goals_scored.empty?

    (goals_scored.reduce(:+) / goals_scored.size.to_f).round(2)
  end

  # by game
  def away_goals_scored(team_id, season = :all, type = :all)
    away_games_played(team_id, season, type).map do |game|
      game['away_goals'].to_i
    end
  end

  def home_goals_scored(team_id, season = :all, type = :all)
    home_games_played(team_id, season, type).map do |game|
      game['home_goals'].to_i
    end
  end

  def away_goals_against(team_id, season = :all, type = :all)
    away_games_played(team_id, season, type).map do |game|
      game['home_goals'].to_i
    end
  end

  def home_goals_against(team_id, season = :all, type = :all)
    home_games_played(team_id, season, type).map do |game|
      game['away_goals'].to_i
    end
  end

  def total_goals_against(team_id, season = :all, type = :all)
    (away_goals_against(team_id, season, type) +
     home_goals_against(team_id, season, type)).reduce(:+) || 0
  end

  def total_goals_scored(team_id, season = :all, type = :all)
    (away_goals_scored(team_id, season, type) +
     home_goals_scored(team_id, season, type)).reduce(:+) || 0
  end

  # by opponent
  def away_games_played_by_opponent(team_id, opponent)
    games.select do |game|
      (game['away_team_id'] == team_id) &&
        (game['home_team_id'] == opponent['team_id'])
    end
  end

  def home_games_played_by_opponent(team_id, opponent)
    games.select do |game|
      (game['home_team_id'] == team_id) &&
        (game['away_team_id'] == opponent['team_id'])
    end
  end

  def total_games_played_by_opponent(team_id, opponent)
    home_games_played_by_opponent(team_id, opponent).size +
      away_games_played_by_opponent(team_id, opponent).size
  end

  def home_games_lost_by_opponent(team_id, opponent)
    home_games_played_by_opponent(team_id, opponent).select do |game|
      game['home_goals'].to_i < game['away_goals'].to_i
    end
  end

  def away_games_lost_by_opponent(team_id, opponent)
    away_games_played_by_opponent(team_id, opponent).select do |game|
      game['away_goals'].to_i < game['home_goals'].to_i
    end
  end

  def away_games_won_by_opponent(team_id, opponent)
    away_games_played_by_opponent(team_id, opponent).select do |game|
      game['away_goals'].to_f > game['home_goals'].to_f
    end
  end

  def home_games_won_by_opponent(team_id, opponent)
    home_games_played_by_opponent(team_id, opponent).select do |game|
      game['home_goals'].to_f > game['away_goals'].to_f
    end
  end

  def total_games_won_by_opponent(team_id, opponent)
    home_games_won_by_opponent(team_id, opponent).size +
      away_games_won_by_opponent(team_id, opponent).size
  end

  def winning_percent_by_opponent(team_id, opponent)
    (total_games_won_by_opponent(team_id, opponent) /
     total_games_played_by_opponent(team_id, opponent).to_f).round(2)
  end
end
