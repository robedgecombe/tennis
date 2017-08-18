require 'rails_helper'

RSpec.describe Tiebreak, type: :model do

	before do
		match.start_match
		create_a_set_that_goes_to_tiebreak
		@tiebreak = this_set.build_tiebreak(status: "in progress")
		@tiebreak.save
	end

	let(:match) { create(:match) }
	let(:match_stats) { match.match_stats }
	let(:player_1) { match_stats.player_1 }
	let(:player_2) { match_stats.player_2 }
	let(:this_set) { match_stats.sets.create(status: 'in progress', number: 1) }

	def create_a_set_that_goes_to_tiebreak
		6.times { this_set.games.create(status: 'complete', server_id: player_1.id, winner_id: player_1.id, loser_id: player_2.id) }
		6.times { this_set.games.create(status: 'complete', server_id: player_2.id, winner_id: player_2.id, loser_id: player_1.id) }
	end

	def player_1_wins_point
		@tiebreak.points.create(status: 'complete', winner: match_stats.player_1)
	end

	def player_2_wins_point
		@tiebreak.points.create(status: 'complete', winner: match_stats.player_2)
	end

	describe 'complete?' do
		context 'player_1 has won seven points' do
			before{ 7.times{ player_1_wins_point } }

			context 'player_2 has won less than six points' do
				before { 5.times{ player_2_wins_point } }

				it 'comletes the tiebreak' do
					expect(@tiebreak.complete?).to be true
				end
			end

			context 'player_2 has won six, seven or eight points' do
				before{ 6.times{ player_2_wins_point } }

				it 'does not complete the tiebreak' do
					expect(@tiebreak.complete?).to_not be true
					player_2_wins_point
					expect(@tiebreak.complete?).to_not be true
					player_2_wins_point
					expect(@tiebreak.complete?).to_not be true
				end
			end

			context 'player_2 has won nine points' do
				before{ 9.times{ player_2_wins_point } }

				it 'does complete the tiebreak' do
					expect(@tiebreak.complete?).to be true
				end
			end
		end

		context 'player_2 has won seven points' do
			before{ 7.times{ player_2_wins_point } }

			context 'player_1 has won less than six points' do
				before { 5.times{ player_1_wins_point } }

				it 'comletes the tiebreak' do
					expect(@tiebreak.complete?).to be true
				end
			end

			context 'player_1 has won six, seven or eight points' do
				before{ 6.times{ player_1_wins_point } }

				it 'does not complete the tiebreak' do
					expect(@tiebreak.complete?).to_not be true
					player_1_wins_point
					expect(@tiebreak.complete?).to_not be true
					player_1_wins_point
					expect(@tiebreak.complete?).to_not be true
				end
			end

			context 'player_1 has won nine points' do
				before{ 9.times{ player_1_wins_point } }

				it 'does complete the tiebreak' do
					expect(@tiebreak.complete?).to be true
				end
			end			
		end
	end

	describe 'complete_tiebreak' do
		subject{ @tiebreak.complete_tiebreak }

		context 'player_1 has won' do
			before do 
				7.times{ player_1_wins_point }
				subject
			end

			it 'assigns player_1 as the winner of the tiebreak' do
				expect(@tiebreak.winner).to eq(player_1)
			end

			it 'assigns player_2 as the loser of the tiebreak' do
				expect(@tiebreak.loser).to eq(player_2)
			end

			it 'completes the set' do
				expect(this_set.reload.status).to eq('complete')
			end

			it 'assigns the winner of the set to player_1' do
				expect(this_set.reload.winner).to eq(player_1)
			end

			it 'assigns the loser of the set to player_2' do
				expect(this_set.reload.loser).to eq(player_2)
			end
		end

		context 'player_2 has won' do
			before do 
				7.times{ player_2_wins_point }
				subject
			end

			it 'assigns player_2 as the winner of the tiebreak' do
				expect(@tiebreak.winner).to eq(player_2)
			end

			it 'assigns player_1 as the loser of the tiebreak' do
				expect(@tiebreak.loser).to eq(player_1)
			end

			it 'completes the set' do
				expect(this_set.reload.status).to eq('complete')
			end

			it 'assigns the winner of the set to player_2' do
				expect(this_set.reload.winner).to eq(player_2)
			end

			it 'assigns the loser of the set to player_1' do
				expect(this_set.reload.loser).to eq(player_1)
			end
		end
	end
end