# frozen_string_literal: true

# comment
module Common
  def total_games_played(team_id, season = :all, type = :all)
    (away_games_played(team_id, season, type).size +
     home_games_played(team_id, season, type).size).to_f
  end

  def total_games_won(team_id, season = :all, type = :all)
    total_home_games_won(team_id, season, type) +
      total_away_games_won(team_id, season, type)
  end

  def winning_percentage(team_id, season = :all, type = :all)
    games_played = total_games_played(team_id, season, type)
    games_won = total_games_won(team_id, season, type)

    winning_percent(games_played, games_won).round(2)
  end

  def home_games_played(team_id, season = :all, type = :all)
    games.select do |game|
      (game['home_team_id'] == team_id) &&
        season_check(game, season) &&
        game_type(game, type)
    end
  end

  def away_games_played(team_id, season = :all, type = :all)
    games.select do |game|
      (game['away_team_id'] == team_id) &&
        season_check(game, season) &&
        game_type(game, type)
    end
  end

  def games_played(team_id, season = :all, type = :all)
    home_games_played(team_id, season, type) +
      away_games_played(team_id, season, type)
  end

  private

  def total_home_games_won(team_id, season = :all, type = :all)
    home_games_played(team_id, season, type).select do |game|
      game['home_goals'].to_f > game['away_goals'].to_f
    end.size
  end

  def total_away_games_won(team_id, season = :all, type = :all)
    away_games_played(team_id, season, type).select do |game|
      game['away_goals'].to_f > game['home_goals'].to_f
    end.size
  end

  def winning_percent(games_played, games_won)
    return 0.0 if games_played.zero?

    (games_won / games_played.to_f)
  end

  def game_type(game, type)
    case type
    when :regular
      (game['type'] == 'Regular Season')
    when :post
      (game['type'] == 'Postseason')
    else # :all
      true
    end
  end

  def season_check(game, season)
    return true if season == :all

    (game['season'] == season)
  end
end
