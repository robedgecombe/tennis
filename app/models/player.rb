class Player < ActiveRecord::Base
	
	belongs_to :match
	validates :name, :energy, presence: true


	def serve
		self.energy -= 1
		is_it_in = rand(4)
		if is_it_in == 0
			puts "what a serve"
			opponent_attempts_to_return_awesome_shot
		elsif is_it_in == 1 || is_it_in == 2
			puts "fault"
			second_serve
		elsif is_it_in == 3
			puts "serve is good"
			opponent_returns_ok_serve
		end			
	end

	def second_serve
		is_it_in = rand(4)
		if is_it_in == 0
			puts "good serve"
			opponent_returns_ok_serve
		elsif is_it_in == 1
			is_it_in == 1
			puts "oh that is a really good serve"
			opponent_attempts_to_return_awesome_shot
		elsif is_it_in == 2
			puts "you can't hit it there"
			opponent_now_has_upper_hand
		else puts "double fault"
			increment_opponent_game_score
		end
	end

	def hit_it_back
		hit_it = rand(4)
		if hit_it == 0
			puts "out. bad luck kiddo"
			increment_opponent_game_score
		elsif hit_it == 1
			puts "ok, at least you got it in"
			opponent_now_has_upper_hand
		elsif hit_it == 2
			puts "that's good, work his backhand"
			opponent_returns_pretty_good_shot
		elsif hit_it == 3
			puts "nice shot what a ripper"
			opponent_attempts_to_return_awesome_shot
		end
	end

	def opponent_attempts_to_return_awesome_shot
		did_he = rand(4)
		if did_he == 0
			puts "ooh and he's got it back!"
			hit_pretty_easy_one_back
		elsif did_he == 1
			puts "nowhere near it!"
			self.increment_game_score
		else puts "it was always going to be a bit much"
			self.increment_game_score			
		end
	end

	def opponent_returns_ok_serve
		did_he = rand(4)
		if did_he == 0
			puts "the opponent has shanked it"
			self.increment_game_score
		elsif did_he == 1 || did_he == 2
			puts "good return, and it is rally on"
			hit_it_back
		else puts "what a brilliant return from the opponent!"
			increment_opponent_game_score
		end
	end

	def opponent_returns_pretty_good_shot
		did_he = rand(4)
		if did_he == 0
			puts "the opponent should have done better with that"
			self.increment_game_score
		elsif did_he == 1
			puts "well it's sitting up nicely for you"
			hit_pretty_easy_one_back
		elsif did_he == 2
			puts "the opponent is in this rally"
			hit_it_back
		else puts "oh that is a great shot"
			attempt_to_return_ripper
		end
	end

	def opponent_now_has_upper_hand
		opponent_slam = rand(4)
		if opponent_slam == 0
			puts "oh that is embarrassing for your opponent"
			self.increment_game_score
		elsif opponent_slam == 1
			puts "it's in, it might be hard to get back though"
			attempt_to_return_ripper
		else puts "you've got no chance, don't even bother"
			increment_opponent_game_score
		end
	end

	def attempt_to_return_ripper
		hit_it = rand(4)
		if hit_it == 0
			puts "good return, you are back in it"
			opponent_returns_pretty_good_shot
		elsif hit_it == 1
			puts "you've gotta at least go for it"
			increment_opponent_game_score
		else
			puts "it's sitting up for your opponent to nail it"
			opponent_now_has_upper_hand
		end
	end

	def hit_pretty_easy_one_back
		slam = rand(4)
		if slam == 0
			puts "oh what a shocker. kick yourself you idiot"
			increment_opponent_game_score
		else puts "fist pump"	
			self.increment_game_score	
		end
	end


	def increment_game_score
		if self.game_score == 0 || self.game_score == 15
			self.game_score += 15
		elsif self.game_score == 30
			self.game_score += 10
		elsif self.game_score == 40 && self.opponent_game_score < 40
			self.increment_set_score
		elsif self.game_score == 40 && self.opponent_game_score == 40
			advantage_server
		end
	end

	def increment_opponent_game_score
		if self.opponent_game_score == 0 || self.opponent_game_score == 15
			self.opponent_game_score += 15
		elsif self.opponent_game_score == 30
			self.opponent_game_score += 10
		elsif self.opponent_game_score == 40 && self.game_score < 40
			self.increment_opponent_set_score
		elsif self.opponent_game_score == 40 && self.game_score == 40
			advantage_receiver
		# elsif self.advantage_receiver_points == 0 && self.advantage_server_points == 1
		# 	deuce
		# elsif self.advantage_receiver_points == 1 && self.opponent_game_score == 40
		# 	self.increment_opponent_set_score
		end
	end

	def increment_set_score
		self.set_score += 1
		puts "game. your score is as follows"
		puts set_score
		new_game
	end

	def increment_opponent_set_score
		self.opponent_set_score += 1
		puts "game. your opponents's score is as follows"
		puts opponent_set_score
		new_game
	end

	def advantage_server
		if advantage_server_points == 0 && advantage_receiver_points == 0
			self.advantage_server_points += 1
			puts "advantage server"
			p advantage_server_points
		elsif advantage_server_points == 0 && advantage_receiver_points == 1
			deuce
		else increment_set_score
		end
	end

	def advantage_receiver
		if advantage_receiver_points == 0 && advantage_server_points == 0
			self.advantage_receiver_points += 1
			puts "advantage receiver"
			p advantage_receiver_points
		elsif advantage_receiver_points == 0 && advantage_server_points == 1
			deuce
		else increment_opponent_set_score
		end
	end

	def deuce
		self.advantage_server_points = 0
		self.advantage_receiver_points = 0
		puts "deuce"
	end

	def new_game
		self.game_score = 0
		self.opponent_game_score = 0
		self.advantage_server_points = 0
		self.advantage_receiver_points = 0
		puts "new game"
	end



end

