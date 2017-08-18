class MatchSet < ActiveRecord::Base
	belongs_to :match_stats
	belongs_to :winner, class_name: 'PlayerStats'
	belongs_to :loser, class_name: 'PlayerStats'
	has_many :games, foreign_key: 'set_id'
	has_one :tiebreak, foreign_key: 'set_id'

	delegate :players, to: :match_stats
	delegate :player_1, to: :match_stats
	delegate :player_2, to: :match_stats

	# don't refer to this method anymore but tests still do, need to get rid of them
	def games_won(player)
		tiebreak_win = tiebreak && tiebreak.winner_id.eql?(player.id) ? 1 : 0
		games.where(winner_id: player.id).count + tiebreak_win
	end

	def current_game
		match_stats.current_game
	end

	def check_status
		complete_set if complete?
	end

	def complete_set
		# winner = games_won(player_1) > games_won(player_2) ? player_1 : player_2 # think I should remove this as of 5 Aug
		winner = player_1.games_won(self) > player_2.games_won(self) ? player_1 : player_2
		update_attributes(status: 'complete', winner: winner, loser: winner.opponent)
		match_stats.check_status
	end

	def complete?
		player_1_games = player_1.games_won(self)
		player_2_games = player_2.games_won(self)
		if player_1_games.eql?(7) || player_2_games.eql?(7)
			true
		elsif player_1_games.eql?(6) || player_2_games.eql?(6)
			player_1_games <= 4 || player_2_games <= 4
		else
			false
		end
	end
end