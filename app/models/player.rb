class Player < ActiveRecord::Base
	extend OrderAsSpecified
	
	# belongs_to :match
	has_many :matches_as_player_1, class_name: 'Match', foreign_key: 'player_1_id'
	has_many :matches_as_player_2, class_name: 'Match', foreign_key: 'player_2_id'
	validates :name, :energy, presence: true

	# after_create :assign_mental_attributes
	validate :skills_ranked_correctly

	# SKILLS_RANKING = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] # need to get return back in
	SKILLS = ["power", "speed", "intelligence", "confidence", "concentration", "accuracy", "first_serve", "second_serve", "backhand", "drop_shot", "net_ability", "return"]
	SKILLS_RANKING = (1..12).to_a


	def matches
		# matches_as_player_1 + matches_as_player_2
		Match.where('player_1_id = :id or player_2_id = :id', id: id)
	end


	def skills_ranked_correctly
		initial_skills_ranking = [confidence, concentration, intelligence, power, speed, backhand, accuracy, net_ability, drop_shot, first_serve, second_serve, self.return]
		unless initial_skills_ranking.sort.eql?(SKILLS_RANKING)
			self.errors[:skills_ranking] = "Skills not ranked correctly"
		end
	end

	def update_stats_after_complete_match
		# binding.pry
		puts 'update those bad boys'
	end

	def assign_mental_attributes
		mental_attributes = ["A. Confidence", "B. Concentration", "C. Intelligence"]
		array = ["A", "B", "C"]
		shuffled = array.shuffle
		choices = []
		while mental_attributes.length > 0
			puts "which attribute do you choose. put the letter down"
			puts "you have a choice of #{mental_attributes.join(", ")}"
			puts "you have chosen the following: so far.... #{choices}.... awesome eh?"
			selection = shuffled[0]
			shuffled.delete_at(0)
			choices.push(selection)
			puts "oh oosh, you chose #{selection}"
			puts "therefore you have now chosen...#{choices} so far"
			puts "this is the current array #{shuffled}"
			if selection == 'A' || selection == 'a' && mental_attributes.include?("A. Confidence")
				mental_attributes.delete("A. Confidence")
				puts "your current choices are #{choices}"
			elsif selection == 'B' || selection == 'b' && mental_attributes.include?("B. Concentration")
				mental_attributes.delete("B. Concentration")
				puts "your current choices are #{choices}"
			elsif selection == 'C' || selection == 'c' && mental_attributes.include?("C. Intelligence")
				mental_attributes.delete("C. Intelligence")
				puts "your current choices are #{choices}"
			else puts "just the letter. put the letter down and nothing else"
				mental_attributes
			end
		end
			if choices[0] == 'A'
				self.confidence = 60
			elsif  choices[1] == 'A'
				self.confidence = 40
			elsif choices[2] == 'A'
				self.confidence = 20
			end
			if choices[0] == 'B'
				self.concentration = 60
			elsif choices[1] == 'B'
				self.concentration = 40
			elsif choices[2] == 'B'
				self.concentration = 20
			end
			if choices[0] == 'C'
				self.intelligence = 60
			elsif choices[1] == 'C'
				self.intelligence = 40
			elsif choices[2] = 'C'
				self.intelligence = 20
			end							
		puts "your choices were....... #{choices.join(", ")}"
		puts "your confidence is.....#{confidence}"
		puts "your concentration is....#{concentration}"
		puts "your intelligence is....#{intelligence}"
	end


	# def serve
	# 	self.energy -= 1
	# 	is_it_in = rand(4)
	# 	if is_it_in == 0
	# 		puts "what a serve"
	# 		opponent_attempts_to_return_awesome_shot
	# 	elsif is_it_in == 1 || is_it_in == 2
	# 		puts "fault"
	# 		second_serve
	# 	elsif is_it_in == 3
	# 		puts "serve is good"
	# 		opponent_returns_ok_serve
	# 	end			
	# end

	# def second_serve
	# 	is_it_in = rand(4)
	# 	if is_it_in == 0
	# 		puts "good serve"
	# 		opponent_returns_ok_serve
	# 	elsif is_it_in == 1
	# 		is_it_in == 1
	# 		puts "oh that is a really good serve"
	# 		opponent_attempts_to_return_awesome_shot
	# 	elsif is_it_in == 2
	# 		puts "you can't hit it there"
	# 		opponent_now_has_upper_hand
	# 	else puts "double fault"
	# 		increment_opponent_game_score
	# 	end
	# end

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

