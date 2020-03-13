# frozen_string_literal: true

# comment
module SeasonStatistics
  # Name of the team with the biggest decrease between
  # regular season and postseason win percentage.
  #
  def biggest_bust(season)
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']

      x = winning_percentage(team_id, season, :regular)
      y = winning_percentage(team_id, season, :post)

      foo[team_name] = (x - y).abs.round(2)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  # Name of the team with the biggest increase between
  # regular season and postseason win percentage.
  #
  def biggest_surprise(season)
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']

      x = winning_percentage(team_id, season, :regular)
      y = winning_percentage(team_id, season, :post)

      foo[team_name] = (x + y).abs.round(2)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  # Name of the Coach with the best win percentage for the season
  #
  def winningest_coach(season)
    season_game_teams = season_game_teams(season)
    foo = {}

    coaches.each do |coach|
      foo[coach] = season_coaching_data(coach, season_game_teams)
    end

    foo.sort_by { |k, _v| -k }.min_by { |_k, v| -v[:winning_percentage] }[0]
  end

  # Name of the Coach with the worst win percentage for the season
  #
  def worst_coach(season)
    season_game_teams = season_game_teams(season)
    foo = {}

    coaches.each do |coach|
      foo[coach] = season_coaching_data(coach, season_game_teams)
    end

    foo
      .reject { |_k, v| (v[:games_coached]).zero? }
      .sort_by { |k, _v| -k }.min_by { |_k, v| v[:winning_percentage] }[0]
  end

  # Name of the Team with the best ratio of shots to goals for the season
  def most_accurate_team(season)
    season_game_teams = season_game_teams(season)
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']

      foo[team_name] = shots_to_goals_ratio(team_id, season_game_teams)
    end

    foo.reject { |_k, v| v == 0.0 }.max_by { |_k, v| v }[0]
  end

  # Name of the Team with the worst ratio of shots to goals for the season
  def least_accurate_team(season)
    season_games = season_game_teams(season)
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']

      foo[team_name] = shots_to_goals_ratio(team_id, season_games)
    end

    foo.reject { |_k, v| v == 0.0 }
       .sort_by { |k, _v| k }
       .min_by { |_k, v| v }[0]
  end

  # Name of the Team with the most tackles in the season
  def most_tackles(season)
    season_games = season_game_teams(season)
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']

      foo[team_name] = { tackles: tackles_by_season(team_id, season_games) }
    end

    foo.reject { |_k, v| (v[:tackles]).zero? }.max_by { |_k, v| v[:tackles] }[0]
  end

  # Name of the Team with the fewest tackles in the season
  def fewest_tackles(season)
    season_games = season_game_teams(season)
    foo = {}

    teams.each do |team|
      team_id   = team['team_id']
      team_name = team['teamName']

      foo[team_name] = { tackles: tackles_by_season(team_id, season_games) }
    end

    foo.reject { |_k, v| (v[:tackles]).zero? }.min_by { |_k, v| v[:tackles] }[0]
  end

  private

  def tackles_by_season(team_id, season_games)
    season_games
      .select { |t| t['team_id'] == team_id }
      .reduce(0) { |sum, v| sum + v['tackles'].to_i }
  end

  def coaches
    game_teams.map { |team| team['head_coach'] }.uniq
  end

  def season_coaching_data(coach, season_game_teams)
    total_games_coached = season_games_coached(coach, season_game_teams).size
    games_won =
      season_games_coached(coach, season_game_teams)
      .select { |game| game[:result] == 'WIN' }.size

    {
      games_coached: total_games_coached,
      games_won: games_won,
      winning_percentage: winning_percent(total_games_coached, games_won)
    }
  end

  def season_games_coached(coach, season_game_teams)
    games_coached = []
    season_game_teams.each do |team|
      next if team['head_coach'] != coach

      game_data = {
        game_id: team['game_id'],
        result: team['result']
      }

      games_coached << game_data
    end

    games_coached
  end

  def season_game_teams(season)
    season_game_ids = season_games(season).map { |game| game['game_id'] }

    game_teams.select do |game|
      season_game_ids.include? game['game_id']
    end
  end

  def shots_to_goals_ratio(team_id, season_games)
    z = season_games.select { |t| t['team_id'] == team_id }

    goals = z.reduce(0) { |sum, v| sum + v['goals'].to_i }
    shots = z.reduce(0) { |sum, v| sum + v['shots'].to_i }

    return 0.0 if shots.zero?

    (goals / shots.to_f).round(2)
  end
end
