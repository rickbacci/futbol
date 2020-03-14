require './test/test_helper'

class LeagueStatisticsTest < Minitest::Test
  def setup
    game_path = './test/fixtures/games.csv'
    team_path = './test/fixtures/teams.csv'
    game_teams_path = './test/fixtures/game_teams.csv'

    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_count_of_teams
    assert_equal 6, @stat_tracker.count_of_teams
  end

  def test_best_offense
    assert_equal 'FC Dallas', @stat_tracker.best_offense
  end

  def test_worst_offense
    assert_equal 'Houston Dynamo', @stat_tracker.worst_offense
  end
end
