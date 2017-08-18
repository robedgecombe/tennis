require 'rails_helper'

describe MatchSet, type: :Model do

	before do
		match.start_match
	end

	let(:match) { create(:match) }
	let(:match_stats) { match.match_stats }
	let(:this_set) { match_stats.sets.create(status: 'in progress', number: 1) }
	# let(:this_game) { this_set.games.create(status: 'in progress', server_id: match_stats.player_2.id) }

	def create_game_won_by_player_1
		this_set.games.create(status: 'complete', server_id: match_stats.player_1.id, winner_id: match_stats.player_1.id)
	end

	def create_game_won_by_player_2
		this_set.games.create(status: 'complete', server_id: match_stats.player_2.id, winner_id: match_stats.player_2.id)
	end

	describe 'complete_set' do
		subject{ this_set.complete_set }

		before do
			6.times { create_game_won_by_player_2 }
		end

		it 'sets the status of the set as complete' do
			subject
			expect(this_set.reload.status).to eq('complete')
		end

		it 'assigns a winner' do
			subject
			expect(this_set.winner).to eq(match_stats.player_2)
		end

		it 'assigns a loser' do
			subject
			expect(this_set.loser).to eq(match_stats.player_1)
		end

		it 'the winner and the loser are not the same person' do
			subject
			expect(this_set.winner).to_not eq(this_set.loser)
		end

		it 'the winner has won more games than the loser' do
			subject
			expect(this_set.games_won(this_set.winner)).to be > (this_set.games_won(this_set.loser))
		end

		it 'checks to see if that completes the match or not' do
			expect(match_stats).to receive(:check_status)
			subject
		end
	end

	describe 'complete?' do
		subject{ this_set.complete? }

		context 'neither player has won six games' do
			it 'returns false' do
				2.times { create_game_won_by_player_1 }
				3.times {	create_game_won_by_player_2 }
				expect(subject).to be false
			end
		end

		context 'player_1 has won six games' do
			 before do
				 6.times { create_game_won_by_player_1 }
			 end

			context 'player_2 has won four or fewer games' do
				it 'returns true' do
					4.times {	create_game_won_by_player_2 }
					expect(subject).to be true
				end
			end

			context 'player_2 has won five or six games' do
				it 'returns false' do
					5.times { create_game_won_by_player_2 }
					expect(subject).to be false
				end
			end
		end

		context 'player_2 has won six games' do
			before do
				6.times {	create_game_won_by_player_2 }
			end

			context 'player_1 has won four or fewer games' do
				it 'returns true' do
					4.times {	create_game_won_by_player_1 }
					expect(subject).to be true
				end
			end

			context 'player_1 has won five or six games' do
				it 'returns false' do
					5.times {	create_game_won_by_player_1 }
					expect(subject).to be false
				end
			end
		end

		context 'player_1 has won seven games' do
			it 'returns true' do
				7.times { create_game_won_by_player_1 }
				6.times { create_game_won_by_player_2 }
				expect(subject).to be true
			end
		end

		context 'player_2 has won seven games' do
			it 'returns true' do
				7.times{ create_game_won_by_player_2 }
				5.times{ create_game_won_by_player_1 }
				expect(subject).to be true
			end
		end
	end
end