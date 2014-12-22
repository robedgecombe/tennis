require 'rails_helper'

RSpec.describe Player, :type => :model do
  describe "#initialize" do
    player1 = Player.create({name: 'Bill'})
    player2 = Player.create({name: 'George', energy: 200})

    it "should create a new Player with name" do
      expect(player1.name). to eq("Bill")
    end

    it "should have some energy" do
    	expect(player1).not_to be_valid
    end

    it "should be valid if he does have some energy" do
  	  expect(player2).to be_valid
	  end

	end
end