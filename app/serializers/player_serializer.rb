class PlayerSerializer < ActiveModel::Serializer

	attributes :player_id,
						 :player_name,
						 :skill_levels


	def player_id
		object.id
	end

	def player_name
		object.name
	end

	def skill_levels
		{
			"energy" => object.energy,
			"game_score" => object.game_score,
			"set_score" => object.set_score,
			"match_score" => object.match_score,
			"opponent_game_score" => object.opponent_game_score,
			"opponent_set_score" => object.opponent_set_score,
			"opponent_match_score" => object.opponent_match_score,
			"advantage_server_points" => object.advantage_server_points,
			"advantage_receiver_points" => object.advantage_receiver_points,
			"confidence" => object.confidence,
			"concentration" => object.concentration,
			"intellegence" => object.intellegence,
			"power" => object.power,
			"speed" => object.speed,
			"backhand" => object.backhand,
			"accuracy" => object.accuracy,
			"net_ability" => object.net_ability,
			"drop_shot" => object.drop_shot,
			"first_serve" => object.first_serve,
			"second_serve" => object.second_serve,
			"return" => object.return
		}
	end

end