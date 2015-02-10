require 'rails_helper'

RSpec.describe Player, :type => :model do
  describe "#initialize" do
    player1 = Player.create({name: 'Bill'})
    player2 = Player.create({name: 'George', energy: nil})

    it "creates a new Player with name" do
      expect(player1.name).to eq("Bill")
    end

    it "has energy of 200" do
    	expect(player1.energy).to eq(200)
    end

    it "is invalid if the energy is not 200" do
  	  expect(player2).not_to be_valid
	  end
  end
    
  #   describe "#serve" do
  #     player3 = Player.create({name: 'Jimmy'})
  #     player3.serve

  #   it "loses one energy when the player serves" do
  #     expect(player3.energy).to eq(199)
  #   end
  # end

    describe "#increment_game_score" do
      player4 = Player.create({name: 'Deano'})
      player5 = Player.create({name: 'Dave'})

    it "gets 15 game_points when the player is on 0 and then wins a point" do
      player4.increment_game_score
      expect(player4.game_score).to eq(15)
    end

    it "gets 15 points if he wins the point and his score is 15" do
      player4.increment_game_score
      expect(player4.game_score).to eq(30)
    end

    it "gets 10 game_points when the player is on 30 and wins the point" do
      player4.increment_game_score
      expect(player4.game_score).to eq(40)
    end

# puts "huh"
# puts player5.energy
# puts "oh"

player5.assign_mental_attributes

# player5.assign_mental_attributes
# puts "confidence is #{player5.confidence}"
# puts "concentration is #{player5.concentration}"
# puts "intelligence is #{player5.intelligence}"

    # player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score

    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score

    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    #  player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score

    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score

    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # player5.serve
    # puts player5.game_score
    # puts player5.opponent_game_score
    # puts "and your energy is.... #{player5.energy}"
  
	end
end