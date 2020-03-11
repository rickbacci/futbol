# frozen_string_literal: true

# comment
module TeamStatistics
  def team_info(team_id)
    # A hash with key/value pairs for the following attributes:
    # team_id, franchise_id, team_name, abbreviation, and link
    teams.each do |team|
      if team['team_id'] == team_id
        return {
          'abbreviation' => team['abbreviation'],
          'franchise_id' => team['franchiseId'],
          'link' => team['link'],
          'team_id' => team['team_id'],
          'team_name' => team['teamName']
        }
      end
    end
  end

  def best_season(team_id)
    # Season with the highest win percentage for a team.
    foo = {}

    seasons.each do |season|
      foo[season] = winning_percentage(team_id, season)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  def worst_season(team_id)
    # Season with the lowest win percentage for a team.
    foo = {}

    seasons.each do |season|
      foo[season] = winning_percentage(team_id, season)
    end

    foo.max_by { |_k, v| -v }[0]
  end

  def average_win_percentage(team_id)
    # Average win percentage of all games for a team.
    (total_games_won(team_id) / total_games_played(team_id)).round(2)
  end

  def most_goals_scored(team_id)
    (away_goals_scored(team_id) + home_goals_scored(team_id)).max
  end

  def fewest_goals_scored(team_id)
    (away_goals_scored(team_id) + home_goals_scored(team_id)).min
  end

  def favorite_opponent(team_id)
    foo = {}
    opponents = teams.reject { |team| team['team_id'] == team_id }

    opponents.each do |opponent|
      opponent_name = opponent['teamName']
      foo[opponent_name] = winning_percent_by_opponent(team_id, opponent)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  def rival(team_id)
    foo = {}
    opponents = teams.reject { |team| team['team_id'] == team_id }

    opponents.each do |opponent|
      opponent_name = opponent['teamName']
      foo[opponent_name] = winning_percent_by_opponent(team_id, opponent)
    end

    foo.min_by { |_k, v| v }[0]
  end

  def biggest_team_blowout(team_id)
    foo = {}
    opponents = teams.reject { |team| team['team_id'] == team_id }

    opponents.each do |opponent|
      opponent_name = opponent['teamName']

      away_games_score_difference =
        away_games_won_by_opponent(team_id, opponent).map do |game|
          (game['away_goals'].to_i - game['home_goals'].to_i).abs
        end

      home_games_score_difference =
        home_games_won_by_opponent(team_id, opponent).map do |game|
          (game['away_goals'].to_i - game['home_goals'].to_i).abs
        end

      foo[opponent_name] =
        (away_games_score_difference +
         home_games_score_difference).first
    end

    foo.min_by { |_k, v| -v }[1]
  end

  def worst_loss(team_id)
    foo = {}
    opponents = teams.reject { |team| team['team_id'] == team_id }

    opponents.each do |opponent|
      opponent_name = opponent['teamName']

      away_games_score_difference =
        away_games_lost_by_opponent(team_id, opponent).map do |game|
          (game['away_goals'].to_i - game['home_goals'].to_i).abs
        end

      home_games_score_difference =
        home_games_lost_by_opponent(team_id, opponent).map do |game|
          (game['away_goals'].to_i - game['home_goals'].to_i).abs
        end

      difference =
        (away_games_score_difference + home_games_score_difference).max

      foo[opponent_name] = difference || 0
    end

    foo.min_by { |_k, v| -v }[1]
  end

  def head_to_head(team_id)
    foo = {}
    opponents = teams.reject { |team| team['team_id'] == team_id }

    opponents.each do |opponent|
      opponent_name = opponent['teamName']
      foo[opponent_name] = winning_percent_by_opponent(team_id, opponent)
    end

    foo
  end

  def seasonal_summary(team_id)
    summary = {}

    seasons.sort.each do |season|
      summary[season] = {
        postseason: {
          win_percentage: winning_percentage(team_id, season, :post),
          total_goals_scored: total_goals_scored(team_id, season, :post),
          total_goals_against: total_goals_against(team_id, season, :post),
          average_goals_scored: average_goals_scored(team_id, season, :post),
          average_goals_against: average_goals_against(team_id, season, :post)
        },
        regular_season: {
          win_percentage: winning_percentage(team_id, season, :regular),
          total_goals_scored: total_goals_scored(team_id, season, :regular),
          total_goals_against: total_goals_against(team_id, season, :regular),
          average_goals_scored: average_goals_scored(team_id, season, :regular),
          average_goals_against: average_goals_against(team_id, season, :regular)
        }
      }
    end

    summary
  end

  private

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
