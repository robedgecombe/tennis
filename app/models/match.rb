class Match < ActiveRecord::Base

	belongs_to :player_1, class_name: 'Player'
	belongs_to :player_2, class_name: 'Player'

	belongs_to :winner, class_name: 'Player'
	belongs_to :loser, class_name: 'Player'

	has_one :match_stats

	validates :player_1_id, presence: true
	validates :player_2_id, presence: true
	delegate :sets, to: :match_stats

	def players
		player_ids = [player_1_id, player_2_id]
		Player.where(id: [player_1_id, player_2_id]).order_as_specified(id: player_ids)
	end

	def start_match
		match_stats = build_match_stats(player_1_stats: PlayerStats.create, player_2_stats: PlayerStats.create)
		attributes = players.collect{ |a| {name: a.name, energy: a.energy, concentration: a.concentration, intelligence: a.intelligence, power: a.power, speed: a.speed, backhand: a.backhand, accuracy: a.accuracy, net_ability: a.net_ability, drop_shot: a.drop_shot, first_serve: a.first_serve, second_serve: a.second_serve, confidence: a.confidence} }
		match_stats.player_1_stats.update_attributes(attributes.first)
		match_stats.player_2_stats.update_attributes(attributes.last)
		match_stats.save
	end

	def complete_match
		winner = match_stats.player_1.sets_won(match_stats) > match_stats.player_2.sets_won(match_stats) ? player_1 : player_2
		loser = players.where('id != :id', id: winner.id).first
		update_attributes(status: 'complete', winner: winner, loser: loser)
		winner.update_stats_after_complete_match
		loser.update_stats_after_complete_match
	end
end
