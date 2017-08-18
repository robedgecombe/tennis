module PlayersHelper

	def order_skills_for_new_player
		skills = @skill_set.keys
		skills.collect{|skill| skill.to_sym }
	end
end