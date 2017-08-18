class Point < ActiveRecord::Base

	belongs_to :winner, class_name: 'PlayerStats'
	belongs_to :loser, class_name: 'PlayerStats'
	belongs_to :server, class_name: 'PlayerStats'
	belongs_to :game
	belongs_to :tiebreak
	has_many :shots

	delegate :players, to: :game_or_tiebreak
	delegate :player_1, to: :game_or_tiebreak
	delegate :player_2, to: :game_or_tiebreak
	delegate :set, :match_stats, to: :game_or_tiebreak

	validate :either_game_or_tiebreak_not_both

	# def initialize
	# 	watch_the_point
	# end

	def watch_the_point(server)
		point_details = server.begin_point(self)
		self.winner = point_details[:winner]
		self.loser = point_details[:loser]
		# binding.pry
		# random = [player_1, player_2].shuffle
		# self.winner = random.first
		# self.loser = random.last
		self.status = "complete"
		self.save
		game ? game.check_status : tiebreak.check_status
	end

	def receiver
		players.where('id != :id', id: server.id).first
	end

	def game_or_tiebreak
		game_id ? game : tiebreak
	end

	def either_game_or_tiebreak_not_both
		# game_id && !tiebreak_id || tiebreak_id && !game_id
		unless game_id.blank? ^ tiebreak_id.blank?
			self.errors[:either_game_or_tiebreak_not_both] = "Must belong to either a game or a tiebreak"
		end
	end
end