class Match < ActiveRecord::Base

	has_many :players
	validates :score, presence: true


def create_player
	@players = ["Federer", "Nadal", "Djokovic", "Murray", "Tsonga", "Wawrinka", "del Potro", "Ferrer", "Cilic"]
	@player_name = @players.shuffle!.pop
	Player.create({name: @player_name})
end


end
