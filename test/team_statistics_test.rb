require './test/test_helper'

class TeamStatisticsTest < Minitest::Test
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

  def test_team_info
    expected = {
      'abbreviation' => 'ATL',
      'franchise_id' => '23',
      'link' => '/api/v1/teams/1',
      'team_id' => '1',
      'team_name' => 'Atlanta United'
    }

    assert_equal expected, @stat_tracker.team_info('1')
  end

  def test_best_season
    assert_equal '2020', @stat_tracker.best_season('1')
  end

  def test_worst_season
    assert_equal '2021', @stat_tracker.worst_season('1')
  end
end
