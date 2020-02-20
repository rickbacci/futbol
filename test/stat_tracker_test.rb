require './test/test_helper'

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_returns_an_instance_of_stat_tracker
    assert_instance_of(StatTracker, @stat_tracker)
  end

  def test_games_csv_data_exists
    assert File.exist?(@locations[:games])
  end

  def test_teams_csv_data_exists
    assert File.exist?(@locations[:teams])
  end

  def test_game_teams_csv_data_exists
    assert File.exist?(@locations[:game_teams])
  end

  def test_stat_tracker_games_are_created
    assert @stat_tracker.games
  end

  def test_stat_tracker_teams_are_created
    assert @stat_tracker.teams
  end

  def test_stat_tracker_game_teams_are_created
    assert @stat_tracker.game_teams
  end
end
