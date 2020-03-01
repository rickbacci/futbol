module TeamStatistics

  def team_info(team_id)
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
    foo = {}

    seasons.each do |season|
        total_games_played_this_season =
          home_games_played_by_season(team_id, season).size +
          away_games_played_by_season(team_id, season).size

        total_games_won_this_season =
          home_games_won_by_season(team_id, season) +
          away_games_won_by_season(team_id, season)

        winning_percent_this_season =
          total_games_won_this_season /
          total_games_played_this_season.to_f

        foo[season] = winning_percent_this_season
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def worst_season(team_id)
    foo = {}

    seasons.each do |season|
          total_games_played_this_season =
            home_games_played_by_season(team_id, season).size +
            away_games_played_by_season(team_id, season).size

          total_games_won_this_season =
            home_games_won_by_season(team_id, season) +
            away_games_won_by_season(team_id, season)

          winning_percent_this_season =
            total_games_won_this_season /
            total_games_played_this_season.to_f

          foo[season] = winning_percent_this_season
    end

    foo.sort_by { |k,v| v }.first[0]
  end

  def average_win_percentage(team_id)
    away_games_won = away_games_played(team_id).select do |game|
      game["away_goals"].to_f > game["home_goals"].to_f
    end.size

    home_games_won = home_games_played(team_id).select do |game|
      game["home_goals"].to_f > game["away_goals"].to_f
    end.size

    total_games_played =
      home_games_played(team_id).size +
      away_games_played(team_id).size

    total_games_won =
      home_games_won + away_games_won

    (total_games_won / total_games_played.to_f).round(2)
  end

  def most_goals_scored(team_id)
    away_goals_scored =
      away_games_played(team_id).map { |game| game["away_goals"].to_i }

    home_goals_scored =
      home_games_played(team_id).map { |game| game["home_goals"].to_i }

    (away_goals_scored + home_goals_scored).sort.last
  end

  def fewest_goals_scored(team_id)
    away_goals_scored =
      away_games_played(team_id).map { |game| game["away_goals"].to_i }

    home_goals_scored =
      home_games_played(team_id).map { |game| game["home_goals"].to_i }

    (away_goals_scored + home_goals_scored).sort.first
  end

  def favorite_opponent(team_id)
    foo = {}
    opponents = teams.select { |team| team["team_id"] != team_id }

    opponents.each do |opponent|
      opponent_name = opponent["teamName"]

      away_games_won =
        away_games_played_by_opponent(team_id, opponent).select do |game|
          game["away_goals"].to_f > game["home_goals"].to_f
        end.size

        home_games_won =
          home_games_played_by_opponent(team_id, opponent).select do |game|
            game["home_goals"].to_f > game["away_goals"].to_f
          end.size

          total_games_played =
            home_games_played_by_opponent(team_id, opponent).size +
            away_games_played_by_opponent(team_id, opponent).size

          total_games_won =
            home_games_won + away_games_won

          foo[opponent_name] = (total_games_won / total_games_played.to_f).round(2)
    end

    foo.sort_by { |k,v| -v }.first[0]
  end

  def rival(team_id)
    foo = {}
    opponents = teams.select { |team| team["team_id"] != team_id }

    opponents.each do |opponent|
      opponent_name = opponent["teamName"]

      away_games_won =
        away_games_played_by_opponent(team_id, opponent).select do |game|
          game["away_goals"].to_f > game["home_goals"].to_f
        end.size

        home_games_won =
          home_games_played_by_opponent(team_id, opponent).select do |game|
          game["home_goals"].to_f > game["away_goals"].to_f
        end.size

        total_games_played =
          home_games_played_by_opponent(team_id, opponent).size +
          away_games_played_by_opponent(team_id, opponent).size

        total_games_won =
          home_games_won +
          away_games_won

        foo[opponent_name] = (total_games_won / total_games_played.to_f).round(2)
    end

    foo.sort_by { |k,v| v }.first[0]
  end

  def biggest_team_blowout(team_id)
    foo = {}
    opponents = teams.select { |team| team["team_id"] != team_id }

    opponents.each do |opponent|
      opponent_name = opponent["teamName"]

      away_games_won =
        away_games_played_by_opponent(team_id, opponent).select do |game|
          game["away_goals"].to_f > game["home_goals"].to_f
        end

      away_games_score_difference = away_games_won.map do |game|
        (game["away_goals"].to_i - game["home_goals"].to_i).abs
      end

      home_games_won =
        home_games_played_by_opponent(team_id, opponent).select do |game|
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
    foo = {}
    opponents = teams.select { |team| team["team_id"] != team_id }

    opponents.each do |opponent|
      opponent_name = opponent["teamName"]

      away_games_lost =
        away_games_played_by_opponent(team_id, opponent).select do |game|
          game["away_goals"].to_i < game["home_goals"].to_i
        end

      away_games_score_difference =
        away_games_lost.map do |game|
          (game["away_goals"].to_i - game["home_goals"].to_i).abs
        end

      home_games_lost =
        home_games_played_by_opponent(team_id, opponent).select do |game|
        game["home_goals"].to_i < game["away_goals"].to_i
      end

      home_games_score_difference = home_games_lost.map do |game|
        (game["away_goals"].to_i - game["home_goals"].to_i).abs
      end
      difference =
        (away_games_score_difference + home_games_score_difference).sort.last

      foo[opponent_name] = difference || 0
    end

    foo.sort_by { |k,v| -v }.first[1]
  end

  def head_to_head(team_id)
    foo = {}
    opponents = teams.select { |team| team["team_id"] != team_id }

    opponents.each do |opponent|
      opponent_name = opponent["teamName"]

      away_games_won =
        away_games_played_by_opponent(team_id, opponent).select do |game|
          game["away_goals"].to_f > game["home_goals"].to_f
        end

      home_games_won =
        home_games_played_by_opponent(team_id, opponent).select do |game|
        game["home_goals"].to_f > game["away_goals"].to_f
      end

      total_games_played =
        home_games_played_by_opponent(team_id, opponent).size +
        away_games_played_by_opponent(team_id, opponent).size

      total_games_won =
        home_games_won.size +
        away_games_won.size

      winning_percent =
        (total_games_won /
         total_games_played.to_f).round(2)

      foo[opponent_name] = winning_percent
    end

    foo
  end

  def seasonal_summary(team_id)
    summary = {}

    seasons.sort.each do |season|
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

      away_games_won_regular_season =
        away_games_played_regular_season.select do |game|
          (game["away_goals"].to_i > game["home_goals"].to_i) &&
            game["type"] == "Regular Season"
        end.size

        home_games_won_regular_season =
          home_games_played_regular_season.select do |game|
            (game["home_goals"].to_i > game["away_goals"].to_i) &&
              game["type"] == "Regular Season"
          end.size

          away_games_won_post_season =
            away_games_played_post_season.select do |game|
              (game["away_goals"].to_i > game["home_goals"].to_i) &&
                game["type"] == "Postseason"
            end.size

            home_games_won_post_season =
              home_games_played_post_season.select do |game|
                (game["home_goals"].to_i > game["away_goals"].to_i) &&
                  game["type"] == "Postseason"
              end.size

              total_games_played_regular_season =
                home_games_played_regular_season.size +
                away_games_played_regular_season.size

              total_games_played_post_season =
                home_games_played_post_season.size +
                away_games_played_post_season.size

              total_games_won_regular_season =
                home_games_won_regular_season +
                away_games_won_regular_season

              total_games_won_post_season =
                home_games_won_post_season +
                away_games_won_post_season

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

              # total_goals_against_post_season
              away_goals_against_post_season =
                away_games_played_post_season.map do |game|
                  game["home_goals"].to_i
                end
              home_goals_against_post_season =
                home_games_played_post_season.map do |game|
                  game["away_goals"].to_i
                end

              # average_goals_against_regular_season
              regular_season_goals_against =
                (away_goals_against_regular_season +
                 home_goals_against_regular_season)

              # average_goals_against_post_season
              post_season_goals_against =
                (away_goals_against_post_season +
                 home_goals_against_post_season)

              # average_goals_scored_post_season
              post_season_goals_scored =
                (away_goals_scored_post_season + home_goals_scored_post_season)

              # average_goals_scored_regular_season
              regular_season_goals_scored =
                (away_goals_scored_regular_season + home_goals_scored_regular_season)

              summary[season] = {
                :postseason => {
                  :win_percentage => winning_percent_by_season(total_games_won_post_season, total_games_played_post_season),
                  :total_goals_scored => total_goals_scored_by_season(away_goals_scored_post_season, home_goals_scored_post_season),
                  :total_goals_against => total_goals_against_by_season(away_goals_against_post_season, home_goals_against_post_season),
                  :average_goals_scored => average_goals_scored_by_season(post_season_goals_scored),
                  :average_goals_against => average_goals_against_by_season(post_season_goals_against)
                },
                :regular_season => {
                  :win_percentage => winning_percent_by_season(total_games_won_regular_season, total_games_played_regular_season),
                  :total_goals_scored => total_goals_scored_by_season(away_goals_scored_regular_season, home_goals_scored_regular_season),
                  :total_goals_against => total_goals_against_by_season(away_goals_against_regular_season, home_goals_against_regular_season),
                  :average_goals_scored => average_goals_scored_by_season(regular_season_goals_scored),
                  :average_goals_against => average_goals_against_by_season(regular_season_goals_against)
                }
              }
    end

    summary
  end


  private


  def total_goals_against_by_season(away_goals_against, home_goals_against)
    (away_goals_against + home_goals_against).reduce(:+) || 0
  end

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

  def away_games_played_by_season(team_id, season)
    games.select do |game|
      (game["away_team_id"] == team_id) && (game["season"] == season)
    end
  end

  def home_games_played_by_season(team_id, season)
    games.select do |game|
      (game["home_team_id"] == team_id) && (game["season"] == season)
    end
  end

  def away_games_played(team_id)
    games.select { |game| (game["away_team_id"] == team_id) }
  end

  def home_games_played(team_id)
    games.select { |game| (game["home_team_id"] == team_id) }
  end


  def away_games_played_by_opponent(team_id, opponent)
    games.select do |game|
      (game["away_team_id"] == team_id) &&
        (game["home_team_id"] == opponent["team_id"])
    end
  end

  def home_games_played_by_opponent(team_id, opponent)
    games.select do |game|
      (game["home_team_id"] == team_id) &&
        (game["away_team_id"] == opponent["team_id"])
    end
  end

  def home_games_won_by_season(team_id, season)
    home_games_played_by_season(team_id, season).select do |game|
      game["home_goals"].to_f > game["away_goals"].to_f
    end.size
  end

  def away_games_won_by_season(team_id, season)
    away_games_played_by_season(team_id, season).select do |game|
      game["away_goals"].to_f > game["home_goals"].to_f
    end.size
  end

  def away_games_won(team_id)
    away_games_played(team_id).select do |game|
      game["away_goals"].to_f > game["home_goals"].to_f
    end.size
  end




end
