require './test/test_helper'

class GameStatisticsTest < Minitest::Test
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

  def test_highest_total_score
    assert_equal 22, @stat_tracker.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 2, @stat_tracker.lowest_total_score
  end

  def test_biggest_blowout
    assert_equal 18, @stat_tracker.biggest_blowout
  end

  def test_percentage_home_wins
    assert_equal 0.56, @stat_tracker.percentage_home_wins
  end

  def test_percentage_visitor_wins
    assert_equal 0.44, @stat_tracker.percentage_visitor_wins
  end

  def test_percentage_ties
    assert_equal 0.0, @stat_tracker.percentage_ties
  end

  def test_count_of_games_by_season
    expected = { '2020' => 8.0, '2021' => 1.0 }

    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    assert_equal 7.89, @stat_tracker.average_goals_per_game
  end

  def test_average_goals_by_season
    expected = { '2020' => 8.38, '2021' => 4.0 }

    assert_equal expected, @stat_tracker.average_goals_by_season
  end
end
