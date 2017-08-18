FactoryGirl.define do
	factory :match do
		status "new"
		player_1 { create(:player) }
		player_2 { create(:player, :player_2) }
	end
end