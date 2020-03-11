# frozen_string_literal: true

# comment
module LeagueStatistics
  def count_of_teams
    # Total number of teams in the data.
    teams.size
  end

  def best_offense
    # Name of the team with the highest average number
    # of goals scored per game across all seasons.
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']
      foo[team_name] = average_goals_scored_per_game(team_id)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  def worst_offense
    # Name of the team with the lowest average number
    # of goals scored per game across all seasons.
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']
      foo[team_name] = average_goals_scored_per_game(team_id)
    end

    foo.max_by { |_k, v| -v }[0]
  end

  def best_defense
    # Name of the team with the lowest
    # average number of goals allowed per game across all seasons.
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']
      foo[team_name] = average_goals_allowed_per_game(team_id)
    end

    foo.min_by { |_k, v| v }[0]
  end

  def worst_defense
    # Name of the team with the highest average number
    # of goals allowed per game across all seasons.
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']
      foo[team_name] = average_goals_allowed_per_game(team_id)
    end

    foo.max_by { |_k, v| v }[0]
  end

  def highest_scoring_visitor
    # Name of the team with the highest average score per game
    # across all seasons when they are away.
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']
      foo[team_name] = average_goals_away(team_id)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  def highest_scoring_home_team
    # Name of the team with the highest average score per game
    # across all seasons when they are home.
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']
      foo[team_name] = average_goals_home(team_id)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  def lowest_scoring_visitor
    # Name of the team with the lowest average score per game
    # across all seasons when they are a visitor.
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']
      foo[team_name] = average_goals_away(team_id)
    end

    foo.max_by { |_k, v| -v }[0]
  end

  def lowest_scoring_home_team
    # Name of the team with the lowest average score per game
    # across all seasons when they are at home.
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']
      foo[team_name] = average_goals_home(team_id)
    end

    foo.max_by { |_k, v| -v }[0]
  end

  def winningest_team
    # Name of the team with the highest win
    # percentage across all seasons.
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']

      foo[team_name] = winning_percentage(team_id)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  def best_fans
    # Name of the team with biggest difference
    # between home and away win percentages.
    foo = {}

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']
      foo[team_name] = home_away_winning_percent_difference(team_id)
    end

    foo.min_by { |_k, v| -v }[0]
  end

  def worst_fans
    # List of names of all teams with
    # better away records than home records.
    foo = []

    teams.each do |team|
      team_id = team['team_id']
      team_name = team['teamName']
      foo << team_name if better_away_record?(team_id)
    end

    foo
  end

  private

  def better_away_record?(team_id)
    total_away_games_won(team_id) > total_home_games_won(team_id)
  end

  def home_away_winning_percent_difference(team_id)
    (away_games_win_percentage(team_id) -
     home_games_win_percentage(team_id))
      .abs.round(2)
  end

  def away_games_win_percentage(team_id)
    total_away_games_won(team_id) /
      total_away_games_played(team_id)
  end

  def home_games_win_percentage(team_id)
    total_home_games_won(team_id) /
      total_home_games_played(team_id)
  end

  def total_away_games_played(team_id)
    away_games_played(team_id).size.to_f
  end

  def total_home_games_played(team_id)
    home_games_played(team_id).size.to_f
  end

  def average_goals_away(team_id)
    away_games_played(team_id).map do |game|
      game['away_goals'].to_i
    end.reduce(:+) / away_games_played(team_id).size.to_f
  end

  def average_goals_home(team_id)
    home_games_played(team_id).map do |game|
      game['home_goals'].to_i
    end.reduce(:+) / home_games_played(team_id).size.to_f
  end

  def average_goals_scored_per_game(team_id)
    if average_goals_home(team_id) > average_goals_away(team_id)
      average_goals_home(team_id)
    else
      average_goals_away(team_id)
    end
  end

  def average_opponent_goals_away(team_id)
    away_games_played(team_id).map do |game|
      game['home_goals'].to_f
    end.reduce(:+) / away_games_played(team_id).size
  end

  def average_opponent_goals_home(team_id)
    home_games_played(team_id).map do |game|
      game['away_goals'].to_f
    end.reduce(:+) / home_games_played(team_id).size
  end

  def average_goals_allowed_per_game(team_id)
    if average_opponent_goals_home(team_id) >
       average_opponent_goals_away(team_id)
      average_opponent_goals_home(team_id).round(2)
    else
      average_opponent_goals_away(team_id).round(2)
    end
  end
end
