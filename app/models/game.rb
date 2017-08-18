class Game < ActiveRecord::Base
	belongs_to :set, class_name: 'MatchSet'
	belongs_to :winner, class_name: 'PlayerStats'
	belongs_to :loser, class_name: 'PlayerStats'
	belongs_to :server, class_name: 'PlayerStats'
	has_many :points

	delegate :players, :match_stats, to: :set
	delegate :player_1, to: :set
	delegate :player_2, to: :set

	# def player_score(player)
	# 	points_won = player.points_won(self)
	# 	if points_won.eql?(1)
	# 		15
	# 	elsif points_won.eql?(2)
	# 		30
	# 	elsif points_won.eql?(3)
	# 		40
	# 	else
	# 		opponent_points_won = player.opponent.points_won(self)
	# 		depends_on_other_player(points_won, opponent_points_won)
	# 	end
	# end

	# def depends_on_other_player(my_points, his_points)
	# 	if my_points.eql?(his_points) || my_points < his_points
	# 		40 # deuce
	# 	elsif (my_points - his_points).eql?(1)
	# 		"Advantage"
	# 	end
	# end

	def check_status
		complete_game if complete?
	end

	def complete?
		player_1_points_won = player_1.points_won(self)
		player_2_points_won = player_2.points_won(self)

		if player_1_points_won >= 4 || player_2_points_won >= 4
			player_1_points_won - player_2_points_won >= 2 || player_2_points_won - player_1_points_won >= 2 ? true : false
		else
			false
		end
	end

	def complete_game
		winner = player_1.points_won(self) > player_2.points_won(self) ? player_1 : player_2
		update_attributes(status: 'complete', winner: winner, loser: winner.opponent)
		set.check_status
	end

end