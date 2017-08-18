class MatchStats < ActiveRecord::Base
	belongs_to :match
	has_many :sets, class_name: 'MatchSet'
	belongs_to :player_1_stats, class_name: 'PlayerStats'
	belongs_to :player_2_stats, class_name: 'PlayerStats'
	# delegate :games, to: :sets

	validates_presence_of :match, :player_1_stats, :player_2_stats

	# def initialize(whatever)
	# 	binding.pry
	# 	who_is_serving_first
	# end

	def players
		PlayerStats.where(id: [player_1_stats_id, player_2_stats_id])
	end

	def player_1
		player_1_stats
	end

	def player_2
		player_2_stats
	end

	def score
		p1_name = ('%-15.15s' % player_1.name)
		p2_name = ('%-15.15s' % player_2.name)
		player_1_score = "#{p1_name}: #{player_1.sets_won(self)} - #{current_set ? player_1.games_won(current_set) : 0} - #{current_game ? player_1.game_score(current_game) : 0}"
		player_2_score = "#{p2_name}: #{player_2.sets_won(self)} - #{current_set ? player_2.games_won(current_set) : 0} - #{current_game ? player_2.game_score(current_game) : 0}"
		puts player_1_score
		puts player_2_score
	end

	def check_status
		match.complete_match if complete?
	end

	def complete?
		player_1_sets = player_1.sets_won(self)
		player_2_sets = player_2.sets_won(self)
		player_1_sets.eql?(2) || player_2_sets.eql?(2) ? true : false
	end

	def current_set
		sets.where(status: "in progress").first
	end

	def starting_a_new_set
		sets.where(status: "in progress").blank? && sets.where(status: "complete").present?
	end

	def current_game
		current_set.games.where(status: "in progress").first if current_set
	end

	def current_tiebreak
		current_set.tiebreak if current_set #.tiebreak.status.eql?("in progress")
	end

	def current_server
		if current_game
			current_game.server
		elsif current_tiebreak || tiebreak_required?
			get_tiebreak_server
		else
			if current_set
				last_game = current_set.games.order(:number).last
				last_server = last_game.server
				players.where('id != :id', id: last_server.id).first
			elsif starting_a_new_set
				last_game = sets.order(:number).last.games.order(:number).last
				last_server = last_game.server
				players.where('id != :id', id: last_server.id).first
			else
				who_is_serving_first
			end
		end
	end

	def tiebreak_required?
		current_set && current_set.games.where(status: "complete").count.eql?(12) && current_set.status.eql?("in progress")
	end

	def get_tiebreak_server
		if current_tiebreak
			number_of_points = current_tiebreak.points.count
			last_point = current_tiebreak.points.last
			last_server = last_point.server
			if number_of_points.even?
				last_server
			else
				last_server.opponent
			end
		else
			who_is_serving_first
		end
	end

	def play_point
		server = current_server
		current_set || sets.create(status: "in progress", number: which_set?)
		# this_game = current_game || current_set.games.create(status: "in progress", server: server, number: which_game?)
		this_game = 
		if current_game
			current_game
		elsif current_tiebreak
			current_tiebreak
		elsif tiebreak_required?
			tiebreak = current_set.build_tiebreak(status: "in progress")
			tiebreak.save
			tiebreak
		else
			current_set.games.create(status: "in progress", server: server, number: which_game?)
		end
		this_point = this_game.points.create(status: "in progress", server: server)
		this_point.watch_the_point(server)
	end

	def which_set?
		sets.where(status: "complete").count + 1
	end

	def which_game?
		current_set.games.where(status: "complete").count + 1
	end

	private

	def who_is_serving_first
		random = [player_1, player_2].shuffle
		@first_server = random.first
		@second_server = random.last
	end

end