require 'rails_helper'

RSpec.describe Match, :type => :model do
  describe "#initialize" do
  	big_match = Match.create
  	player1 = Player.create({name: "Bill"})

  it "begins with the score as 0" do
  	expect(big_match.score).to eq(0)
  end

  it "goes up 15 when the player serves" do
  	player1.serve
  	expect(big_match.score).to eq(15)
  end

  end
end
