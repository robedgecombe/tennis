class PlayerStats < ActiveRecord::Base

	# has_many :sets_won, class_name: 'MatchSet', foreign_key: 'winner_id'
	# has_many :sets_lost, class_name: 'MatchSet', foreign_key: 'loser_id'
	# has_many :games_on_serve, class_name: 'Game', foreign_key: 'server_id'

	# validate :match_stats

	def match_stats
		MatchStats.where('player_1_stats_id = :id or player_2_stats_id = :id', id: id).first || errors.add(:match_stats, 'does not exist')
	end

	def opponent
		match_stats.player_1_stats_id.eql?(id) ? match_stats.player_2 : match_stats.player_1
	end

	def points_won(game)
		game.points.where(winner_id: id).count
	end

	def game_score(game)
		number_of_points_won = points_won(game)
		if number_of_points_won.eql?(0)
			0
		elsif number_of_points_won.eql?(1)
			15
		elsif number_of_points_won.eql?(2)
			30
		elsif number_of_points_won.eql?(3)
			40
		else
			opponent_points_won = opponent.points_won(game)
			depends_on_other_player(number_of_points_won, opponent_points_won)
		end
	end

	def games_won(set)
		tiebreak_win = set.tiebreak && set.tiebreak.winner_id.eql?(id) ? 1 : 0
		set.games.where(winner_id: id).count + tiebreak_win
	end

	def sets_won(match_stats)
		match_stats.sets.where(winner_id: id).count
	end

	def begin_point(point)
		first_serve = point.shots.create(hitter_id: id, receiver_id: opponent.id, type: 'FirstServe', good: FirstServe.good?)
		if first_serve.good
			details = opponent.return_serve(point)
		else
			second_serve = point.shots.create(hitter_id: id, receiver_id: opponent.id, type: 'SecondServe', good: SecondServe.good?)
			if second_serve.good
				details = opponent.return_serve(point)
			else
				details = { winner: opponent, loser: self }
			end
		end
		details
	end

	def return_serve(point)
		this_return_serve = point.shots.create(hitter_id: id, receiver_id: opponent.id, type: 'ReturnServe', good: ReturnServe.good?)
		if this_return_serve.good
			details = opponent.continue_rally(point)
		else
			details = { winner: opponent, loser: self }
		end
		details
	end

	def continue_rally(point)
		hitter_determinator = 0
		while true
			this_hitter = hitter_determinator.even? ? self : opponent
			this_shot = point.shots.create(hitter_id: this_hitter.id, receiver_id: this_hitter.opponent.id, type: 'GeneralPlayShot', good: GeneralPlayShot.good?)
			hitter_determinator += 1
			break if details = winner_and_loser_determined(this_shot)
		end
		details
	end

	def winner_and_loser_determined(this_shot)
		if this_shot.good
			# this_shot.receiver.can_get_to_the_ball?(this_shot) ? nil : { winner: this_shot.hitter, loser: this_shot.receiver }
			if this_shot.receiver.can_get_to_the_ball?(this_shot)
				nil
			else
				this_shot.update_attributes(winner: true)
				{ winner: this_shot.hitter, loser: this_shot.receiver }
			end
		else
			{ winner: this_shot.receiver, loser: this_shot.hitter }
		end
	end

	def can_get_to_the_ball?(shot)
		random_number = rand(10)
		random_number <= 4 ? true : false
	end

	private

	def depends_on_other_player(my_points, his_points)
		if my_points.eql?(his_points) || my_points < his_points
			40 # deuce
		elsif (my_points - his_points).eql?(1)
			"Advantage"
		end
	end

end

