class Match < ActiveRecord::Base

	after_create :bootstrap

	has_many :players
	validates :score, presence: true


# def initialize(name)
# 	you = @you
#   him = @him
# end


def bootstrap
	self.create_players
	puts "you are both playing in match number #{self.id}"	
end

def create_players
	players = ["Federer", "Nadal", "Djokovic", "Murray", "Tsonga", "Wawrinka", "del Potro", "Ferrer", "Cilic"]
	your_name = players.shuffle!.pop
	his_name = players.shuffle!.pop
	@you = Player.create({name: your_name, match_id: id})
	@him = Player.create({name: his_name, match_id: id})
	puts "You are #{@you.name} and your id is #{@you.id}"
	puts "he is #{@him.name} and his id is #{@him.id}"
end



end
