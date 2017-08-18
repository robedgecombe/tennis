class Tiebreak < ActiveRecord::Base
	belongs_to :set, class_name: 'MatchSet'
	belongs_to :winner, class_name: 'PlayerStats'
	belongs_to :loser, class_name: 'PlayerStats'
	has_many :points

	delegate :players, to: :set
	delegate :player_1, to: :set
	delegate :player_2, to: :set
	validates :set_id, presence: true

	def check_status
		complete_tiebreak if complete?
	end

	def complete?
		player_1_points_won = player_1.points_won(self)
		player_2_points_won = player_2.points_won(self)

		if player_1_points_won >= 7 || player_2_points_won >= 7
			player_1_points_won - player_2_points_won >= 2 || player_2_points_won - player_1_points_won >= 2 ? true : false
		else
			false
		end
	end

	def complete_tiebreak
		winner = player_1.points_won(self) > player_2.points_won(self) ? player_1 : player_2
		update_attributes(status: 'complete', winner: winner, loser: winner.opponent)
		set.complete_set
	end
end