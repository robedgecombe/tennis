require 'rails_helper'

RSpec.describe Match, :type => :model do
  describe "#initialize" do
  	big_match = Match.create
  	player1 = Player.create({name: "Bill"})

  it "begins with the score as 0" do
  	expect(big_match.score).to eq(0)
  end

  end

  it "has a player" do
    new_match = Match.create
    expect(new_match.players.name).to eq("Jim")
  end
  another_match = Match.create
  puts "yep ah yep this is"
  puts another_match.id
    puts "yeah man"
    you_are = Player.find(match_id)
    puts you_are
    puts "awesome"
end
