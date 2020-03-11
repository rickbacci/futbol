# frozen_string_literal: true

# comment
module SeasonStatistics
  def biggest_bust(season)
    # Name of the team with the biggest decrease between
    # regular season and postseason win percentage.
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

  def biggest_surprise(season)
    # Name of the team with the biggest increase between
    # regular season and postseason win percentage.
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

  def winningest_coach(season)
    # Name of the Coach with the best win percentage for the season
    season_game_ids = season_games(season).map { |game| game['game_id'] }

    season_game_teams = game_teams.select do |game|
      season_game_ids.include? game['game_id']
    end

    foo = {}
    coaches.each do |coach|
      foo[coach] = []

      season_game_teams.each do |team|
        next if team['head_coach'] != coach

        game_data = {
          game_id: team['game_id'],
          result: team['result']
        }

        foo[coach] << game_data
      end

      games_coached = foo[coach].size
      games_won = foo[coach].select { |game| game[:result] == 'WIN' }.size
      winning_percentage =
        games_coached.zero? ? 0.0 : (games_won / games_coached.to_f).round(2)

      season_coaching_data = {
        games_coached: games_coached,
        games_won: games_won,
        winning_percentage: winning_percentage
      }

      foo[coach] = season_coaching_data
    end

    foo.sort_by { |k, _v| -k }.min_by { |_k, v| -v[:winning_percentage] }[0]
  end

  def worst_coach(season)
    # Name of the Coach with the worst win percentage for the season
    season_game_ids = season_games(season).map { |game| game['game_id'] }

    season_game_teams = game_teams.select do |game|
      season_game_ids.include? game['game_id']
    end

    foo = {}
    coaches.each do |coach|
      foo[coach] = []

      season_game_teams.each do |team|
        next if team['head_coach'] != coach

        game_data = {
          game_id: team['game_id'],
          result: team['result']
        }

        foo[coach] << game_data
      end

      games_coached = foo[coach].size
      games_won = foo[coach].select { |game| game[:result] == 'WIN' }.size
      winning_percentage =
        games_coached.zero? ? 0.0 : (games_won / games_coached.to_f).round(2)

      season_coaching_data = {
        games_coached: games_coached,
        games_won: games_won,
        winning_percentage: winning_percentage
      }

      foo[coach] = season_coaching_data
    end

    foo
      .reject { |_k, v| (v[:games_coached]).zero? }
      .sort_by { |k, _v| -k }.min_by { |_k, v| v[:winning_percentage] }[0]
  end

  def most_accurate_team(season)
    # Name of the Team with the best ratio of shots to goals for the season
    season_game_ids = season_games(season).map { |game| game['game_id'] }

    season_game_teams = game_teams.select do |game|
      season_game_ids.include? game['game_id']
    end

    foo = {}
    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']

      z = season_game_teams.select { |t| t['team_id'] == team_id }
      # add shots and goals..figure percent

      goals = z.reduce(0) { |sum, v| sum + v['goals'].to_i }
      shots = z.reduce(0) { |sum, v| sum + v['shots'].to_i }

      if shots.zero?
        team_data = {
          shots_to_goals_ratio: 0.0
        }
      else
        team_data = {
          shots_to_goals_ratio: (goals / shots.to_f).round(2)
        }
      end

      foo[team_name] = team_data
    end

    foo
      .reject { |_k, v| v[:shots_to_goals_ratio] == 0.0 }
      .max_by { |_k, v| v[:shots_to_goals_ratio] }[0]
  end

  def least_accurate_team(season)
    # Name of the Team with the worst ratio of shots to goals for the season
    season_game_ids = season_games(season).map { |game| game['game_id'] }

    season_game_teams = game_teams.select do |game|
      season_game_ids.include? game['game_id']
    end

    foo = {}
    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']

      z = season_game_teams.select { |t| t['team_id'] == team_id }
      # add shots and goals..figure percent

      goals = z.reduce(0) { |sum, v| sum + v['goals'].to_i }
      shots = z.reduce(0) { |sum, v| sum + v['shots'].to_i }

      if shots.zero?
        team_data = {
          shots_to_goals_ratio: 0.0
        }
      else
        team_data = {
          shots_to_goals_ratio: (goals / shots.to_f).round(2)
        }
      end

      foo[team_name] = team_data
    end

    foo.reject { |_k, v| v[:shots_to_goals_ratio] == 0.0 }
       .sort_by { |k, _v| k }
       .sort_by { |_k, v| v[:shots_to_goals_ratio] }.first[0]
  end

  def most_tackles(season)
    # Name of the Team with the most tackles in the season
    season_game_ids = season_games(season).map { |game| game['game_id'] }

    season_game_teams = game_teams.select do |game|
      season_game_ids.include? game['game_id']
    end

    foo = {}
    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']

      z = season_game_teams.select { |t| t['team_id'] == team_id }

      tackles = z.reduce(0) { |sum, v| sum + v['tackles'].to_i }

      team_data = {
        tackles: tackles
      }

      foo[team_name] = team_data
    end

    foo.reject { |_k, v| (v[:tackles]).zero? }
       .max_by { |_k, v| v[:tackles] }[0]
  end

  def fewest_tackles(season)
    # Name of the Team with the fewest tackles in the season
    season_game_ids = season_games(season).map { |game| game['game_id'] }

    season_game_teams = game_teams.select do |game|
      season_game_ids.include? game['game_id']
    end

    foo = {}
    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']

      z = season_game_teams.select { |t| t['team_id'] == team_id }

      tackles = z.reduce(0) { |sum, v| sum + v['tackles'].to_i }

      team_data = {
        tackles: tackles
      }

      foo[team_name] = team_data
    end

    foo.reject { |_k, v| (v[:tackles]).zero? }
       .min_by { |_k, v| v[:tackles] }[0]
  end

  private

  def coaches
    game_teams.map { |team| team['head_coach'] }.uniq
  end
end
