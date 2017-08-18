FactoryGirl.define do
  factory :player do
	name 'Bobby Boy'
	energy 200
	confidence 1
    concentration 2
    intelligence 3
    power 4
    speed 5
    backhand 6
    accuracy 7
    net_ability 8
    drop_shot 9
    first_serve 10
    second_serve 11
    self.return 12
  end

  trait :player_2 do 
    name 'Jonny Bravo'
  end
end