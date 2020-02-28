module TeamStatistics

  def team_info(team_id)
    # A hash with key/value pairs for the following attributes:
    # team_id, franchise_id, team_name, abbreviation, and link
    teams.each do |team|
      if team["team_id"] == team_id
        return {
          "abbreviation"=>team["abbreviation"],
          "franchise_id"=>team["franchiseId"],
          "link"=>team["link"],
          "team_id"=>team["team_id"],
          "team_name"=>team["teamName"]
        }
      end
    end
  end

  def best_season(team_id)
    # Season with the highest win percentage for a team.
    # returns a String i.e. "20132014"
    foo = {}

    seasons.each do |season|
      away_games_played_this_season = games.select do |game|
        (game["away_team_id"] == team_id) && (game["season"] == season)
      end

      home_games_played_this_season = games.select do |game|
        (game["home_team_id"] == team_id) && (game["season"] == season)
      end

      away_games_won_this_season = away_games_played_this_season.select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end.size

      home_games_won_this_season = home_games_played_this_season.select do |game|
        game["home_goals"].to_f > game["away_goals"].to_f
      end.size

      total_games_played_this_season =
        home_games_played_this_season.size + away_games_played_this_season.size

      total_games_won_this_season =
        home_games_won_this_season + away_games_won_this_season

      winning_percent_this_season =
        total_games_won_this_season / total_games_played_this_season.to_f

      foo[season] = winning_percent_this_season
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def worst_season(team_id)
    # Season with the lowest win percentage for a team.
    # returns a String i.e. "20132014"
    foo = {}

    seasons.each do |season|
      away_games_played_this_season = games.select do |game|
        (game["away_team_id"] == team_id) && (game["season"] == season)
      end

      home_games_played_this_season = games.select do |game|
        (game["home_team_id"] == team_id) && (game["season"] == season)
      end

      away_games_won_this_season = away_games_played_this_season.select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end.size

      home_games_won_this_season = home_games_played_this_season.select do |game|
        game["home_goals"].to_f > game["away_goals"].to_f
      end.size

      total_games_played_this_season =
        home_games_played_this_season.size + away_games_played_this_season.size

      total_games_won_this_season =
        home_games_won_this_season + away_games_won_this_season

      winning_percent_this_season =
        total_games_won_this_season / total_games_played_this_season.to_f

      foo[season] = winning_percent_this_season
    end

    foo.sort_by { |k,v| v }.first[0]
  end

  def average_win_percentage(team_id)
    # Average win percentage of all games for a team.
    # returns a Float

    away_games_played = games.select do |game|
      (game["away_team_id"] == team_id)
    end

    home_games_played = games.select do |game|
      (game["home_team_id"] == team_id)
    end

    away_games_won = away_games_played.select do |game|
      game["away_goals"].to_f > game["home_goals"].to_f
    end.size

    home_games_won = home_games_played.select do |game|
      game["home_goals"].to_f > game["away_goals"].to_f
    end.size

    total_games_played =
      home_games_played.size + away_games_played.size

    total_games_won =
      home_games_won + away_games_won

    (total_games_won / total_games_played.to_f).round(2)
  end

  def most_goals_scored(team_id)
    # Highest number of goals a particular team has scored in a single game.
    # returns Integer

    away_games_played = games.select do |game|
      (game["away_team_id"] == team_id)
    end

    home_games_played = games.select do |game|
      (game["home_team_id"] == team_id)
    end

    away_goals_scored =
      away_games_played.map { |game| game["away_goals"].to_i }

    home_goals_scored =
      home_games_played.map { |game| game["home_goals"].to_i }

    (away_goals_scored + home_goals_scored).sort.last
  end

  def fewest_goals_scored(team_id)
    # Fewest number of goals a particular team has scored in a single game.
    # returns Integer

    away_games_played = games.select do |game|
      (game["away_team_id"] == team_id)
    end

    home_games_played = games.select do |game|
      (game["home_team_id"] == team_id)
    end

    away_goals_scored =
      away_games_played.map { |game| game["away_goals"].to_i }

    home_goals_scored =
      home_games_played.map { |game| game["home_goals"].to_i }

    (away_goals_scored + home_goals_scored).sort.first
  end

  def favorite_opponent(team_id)
    # Name of the opponent that has the lowest win
    # percentage against the given team.
    # returns String
    foo = {}
    opponents = teams.select { |team| team["team_id"] != team_id }

    opponents.each do |opponent|
      opponent_name = opponent["teamName"]

      away_games_played = games.select do |game|
        (game["away_team_id"] == team_id) &&
          (game["home_team_id"] == opponent["team_id"])
      end

      home_games_played = games.select do |game|
        (game["home_team_id"] == team_id) &&
          (game["away_team_id"] == opponent["team_id"])
      end

      away_games_won = away_games_played.select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end.size

      home_games_won = home_games_played.select do |game|
        game["home_goals"].to_f > game["away_goals"].to_f
      end.size

      total_games_played =
        home_games_played.size + away_games_played.size

      total_games_won =
        home_games_won + away_games_won

      foo[opponent_name] = (total_games_won / total_games_played.to_f).round(2)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def rival(team_id)
    # Name of the opponent that has the highest win
    # percentage against the given team.
    # returns String
    foo = {}
    opponents = teams.select { |team| team["team_id"] != team_id }

    opponents.each do |opponent|
      opponent_name = opponent["teamName"]

      away_games_played = games.select do |game|
        (game["away_team_id"] == team_id) &&
          (game["home_team_id"] == opponent["team_id"])
      end

      home_games_played = games.select do |game|
        (game["home_team_id"] == team_id) &&
          (game["away_team_id"] == opponent["team_id"])
      end

      away_games_won = away_games_played.select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end.size

      home_games_won = home_games_played.select do |game|
        game["home_goals"].to_f > game["away_goals"].to_f
      end.size

      total_games_played =
        home_games_played.size + away_games_played.size

      total_games_won =
        home_games_won + away_games_won

      foo[opponent_name] = (total_games_won / total_games_played.to_f).round(2)
    end

    foo.sort_by { |k,v| v }.first[0]
  end

  def biggest_team_blowout(team_id)
    # Biggest difference between team goals and
    # opponent goals for a win for the given team.
    foo = {}
    opponents = teams.select { |team| team["team_id"] != team_id }

    opponents.each do |opponent|
      opponent_name = opponent["teamName"]

      away_games_played = games.select do |game|
        (game["away_team_id"] == team_id) &&
          (game["home_team_id"] == opponent["team_id"])
      end

      home_games_played = games.select do |game|
        (game["home_team_id"] == team_id) &&
          (game["away_team_id"] == opponent["team_id"])
      end

      away_games_won = away_games_played.select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end

      away_games_score_difference = away_games_won.map do |game|
        (game["away_goals"].to_i - game["home_goals"].to_i).abs
      end

      home_games_won = home_games_played.select do |game|
        game["home_goals"].to_f > game["away_goals"].to_f
      end

      home_games_score_difference = home_games_won.map do |game|
        (game["away_goals"].to_i - game["home_goals"].to_i).abs
      end

      foo[opponent_name] =
        (away_games_score_difference + home_games_score_difference).first
    end

    foo.sort_by { |k,v| -v }.first[1]
  end

  def worst_loss(team_id)
    # Biggest difference between team goals and
    # opponent goals for a loss for the given team.
    foo = {}
    opponents = teams.select { |team| team["team_id"] != team_id }

    opponents.each do |opponent|
      opponent_name = opponent["teamName"]

      away_games_played = games.select do |game|
        (game["away_team_id"] == team_id) &&
          (game["home_team_id"] == opponent["team_id"])
      end

      home_games_played = games.select do |game|
        (game["home_team_id"] == team_id) &&
          (game["away_team_id"] == opponent["team_id"])
      end

      away_games_lost = away_games_played.select do |game|
        game["away_goals"].to_i < game["home_goals"].to_i
      end

      away_games_score_difference = away_games_lost.map do |game|
        (game["away_goals"].to_i - game["home_goals"].to_i).abs
      end

      home_games_lost = home_games_played.select do |game|
        game["home_goals"].to_i < game["away_goals"].to_i
      end

      home_games_score_difference = home_games_lost.map do |game|
        (game["away_goals"].to_i - game["home_goals"].to_i).abs
      end
      difference =
        (away_games_score_difference + home_games_score_difference).sort.last

      # set difference to 0 if value is nil
      foo[opponent_name] = difference || 0
    end

    foo.sort_by { |k,v| -v }.first[1]
  end

  def head_to_head(team_id)
    # Record (as a hash - win/loss) against all opponents
    # with the opponents' names as keys and the win percentage
    # against that opponent as a value.
    foo = {}
    opponents = teams.select { |team| team["team_id"] != team_id }

    opponents.each do |opponent|
      opponent_name = opponent["teamName"]

      away_games_played = games.select do |game|
        (game["away_team_id"] == team_id) &&
          (game["home_team_id"] == opponent["team_id"])
      end

      home_games_played = games.select do |game|
        (game["home_team_id"] == team_id) &&
          (game["away_team_id"] == opponent["team_id"])
      end

      away_games_won = away_games_played.select do |game|
        game["away_goals"].to_f > game["home_goals"].to_f
      end

      home_games_won = home_games_played.select do |game|
        game["home_goals"].to_f > game["away_goals"].to_f
      end

      total_games_played =
        home_games_played.size + away_games_played.size

      total_games_won =
        home_games_won.size + away_games_won.size

      winning_percent =
        (total_games_won / total_games_played.to_f).round(2)

      foo[opponent_name] = winning_percent
    end

    foo
  end

  def seasonal_summary(team_id)
    # For each season that the team has played,
    # a hash that has two keys (:regular_season and :postseason),
    # that each point to a hash with the following keys:
    # :win_percentage, :total_goals_scored, :total_goals_against,
    # :average_goals_scored, :average_goals_against.
    foo = {}

    # foobar = games.map { |game| game["season"] }.uniq
    foobar = ["20122013"]
    foobar.sort.each do |season|

      # Home and away games played in the regular season
      away_games_played_regular_season = games.select do |game|
        (game["away_team_id"] == team_id) &&
          (game["season"] == season) &&
          game["type"] == "Regular Season"
      end

      home_games_played_regular_season = games.select do |game|
        (game["home_team_id"] == team_id) &&
          (game["season"] == season) &&
          game["type"] == "Regular Season"
      end

      # Home and away games played in the postseason
      away_games_played_post_season = games.select do |game|
        (game["away_team_id"] == team_id) &&
          (game["season"] == season) &&
          game["type"] == "Postseason"
      end

      home_games_played_post_season = games.select do |game|
        (game["home_team_id"] == team_id) &&
          (game["season"] == season) &&
          game["type"] == "Postseason"
      end

      away_games_won_regular_season = away_games_played_regular_season.select do |game|
        (game["away_goals"].to_i > game["home_goals"].to_i) &&
          game["type"] == "Regular Season"
      end.size

      home_games_won_regular_season = home_games_played_regular_season.select do |game|
        (game["home_goals"].to_i > game["away_goals"].to_i) &&
          game["type"] == "Regular Season"
      end.size

      away_games_won_post_season = away_games_played_post_season.select do |game|
        (game["away_goals"].to_i > game["home_goals"].to_i) &&
          game["type"] == "Postseason"
      end.size

      home_games_won_post_season = home_games_played_post_season.select do |game|
        (game["home_goals"].to_i > game["away_goals"].to_i) &&
          game["type"] == "Postseason"
      end.size

      total_games_played_regular_season =
        home_games_played_regular_season.size + away_games_played_regular_season.size

      total_games_played_post_season =
        home_games_played_post_season.size + away_games_played_post_season.size

      total_games_won_regular_season =
        home_games_won_regular_season + away_games_won_regular_season

      total_games_won_post_season =
        home_games_won_post_season + away_games_won_post_season

      # total goals scored in postseason
      away_goals_scored_post_season =
        away_games_played_post_season.map do |game|
          game["away_goals"].to_i
        end
      home_goals_scored_post_season =
        home_games_played_post_season.map do |game|
          game["home_goals"].to_i
        end

      # total_goals_scored_regular_season
      away_goals_scored_regular_season =
        away_games_played_regular_season.map do |game|
          game["away_goals"].to_i
        end
      home_goals_scored_regular_season =
        home_games_played_regular_season.map do |game|
          game["home_goals"].to_i
        end

      # total_goals_against_regular_season
      away_goals_against_regular_season =
        away_games_played_regular_season.map do |game|
          game["home_goals"].to_i
        end
      home_goals_against_regular_season =
        home_games_played_regular_season.map do |game|
          game["away_goals"].to_i
        end
      total_goals_against_regular_season =
        (away_goals_against_regular_season +
         home_goals_against_regular_season).reduce(:+) || 0


      # total_goals_against_post_season
      away_goals_against_post_season =
        away_games_played_post_season.map do |game|
          game["home_goals"].to_i
        end
      home_goals_against_post_season =
        home_games_played_post_season.map do |game|
          game["away_goals"].to_i
        end
      total_goals_against_post_season =
        (away_goals_against_post_season +
         home_goals_against_post_season).reduce(:+) || 0

      # average_goals_against_regular_season
      regular_season_goals_against =
        (away_goals_against_regular_season + home_goals_against_regular_season)

      # average_goals_against_post_season
      post_season_goals_against =
        (away_goals_against_post_season + home_goals_against_post_season)

      # average_goals_scored_post_season
      post_season_goals_scored =
        (away_goals_scored_post_season + home_goals_scored_post_season)

      # average_goals_scored_regular_season
      regular_season_goals_scored =
        (away_goals_scored_regular_season + home_goals_scored_regular_season)

      foo[season] = {
        :postseason => {
          :win_percentage => winning_percent_by_season(total_games_won_post_season, total_games_played_post_season),
          :total_goals_scored => total_goals_scored_by_season(away_goals_scored_post_season, home_goals_scored_post_season),
          :total_goals_against => total_goals_against_post_season,
          :average_goals_scored => average_goals_scored_by_season(post_season_goals_scored),
          :average_goals_against => average_goals_against_by_season(post_season_goals_against)
        },
        :regular_season => {
          :win_percentage => winning_percent_by_season(total_games_won_regular_season, total_games_played_regular_season),
          :total_goals_scored => total_goals_scored_by_season(away_goals_scored_regular_season, home_goals_scored_regular_season),
          :total_goals_against => total_goals_against_regular_season,
          :average_goals_scored => average_goals_scored_by_season(regular_season_goals_scored),
          :average_goals_against => average_goals_against_by_season(regular_season_goals_against)
        }
      }
    end

    foo
  end


  private


  def total_goals_scored_by_season(away_goals_scored, home_goals_scored)
    (away_goals_scored + home_goals_scored).reduce(:+) || 0
  end

  def winning_percent_by_season(games_won, games_played)
    return 0.0 if games_played == 0
    (games_won / games_played.to_f).round(2)
  end

  def average_goals_against_by_season(goals_against)
    return 0.0 if goals_against.empty?
    (goals_against.reduce(:+) / goals_against.size.to_f).round(2)
  end

  def average_goals_scored_by_season(goals_scored)
    return 0.0 if goals_scored.empty?
    (goals_scored.reduce(:+) / goals_scored.size.to_f).round(2)
  end

  def seasons
    games.map { |game| game["season"] }.uniq.sort
  end

end
