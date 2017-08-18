require 'rails_helper'

describe PlayerStats, type: :Model do

	before do
		match.start_match
	end

	let(:match) { create(:match) }
	let(:match_stats) { match.match_stats }
	let(:player_1) { match_stats.player_1 }
	let(:player_2) { match_stats.player_2 }
	let(:this_set) { match_stats.sets.create(status: 'in progress', number: 1) }
	let(:this_game) { this_set.games.create(status: 'in progress', server_id: 'player_1.id') }
	let(:point) { this_game.points.create(status: 'in progress', server: this_game.server) }
	let(:details) { { winner: player_1, loser: player_2 } }

	def create_a_point_won_by_player_1
		this_game.points.create(server: player_1, winner: player_1)
	end

	def create_a_point_won_by_player_2
		this_game.points.create(server: player_1, winner: player_2)
	end

	def create_a_game_won_by_player_2
		this_set.games.create(status: 'complete', winner_id: player_2.id, server_id: player_2.id)
	end

	def create_set_won_by_player_1
		match_stats.sets.create(status: 'complete', winner: player_1, loser: player_2)
	end

	def create_set_won_by_player_2
		match_stats.sets.create(status: 'complete', winner: player_2, loser: player_1)
	end

	describe 'match_stats' do
		it 'returns an instance of match_stats' do
			expect(player_1.match_stats).to eq(match_stats)
		end
	end

	describe 'opponent' do
		it 'returns the other player in the match' do
			expect(player_1.opponent).to eq(player_2)
		end
	end

	describe 'points_won' do
		it 'returns the number of points this player has won in the game passed in' do
			2.times{ create_a_point_won_by_player_1 }
			expect(player_1.points_won(this_game)).to eq(2)
		end
	end

	describe 'game_score' do
		it 'returns the score of the current game accurately for this player' do
			3.times{ create_a_point_won_by_player_1 }
			expect(player_1.game_score(this_game)).to eq(40)
		end

		it 'takes into account the other player when it comes to deuce and advantage' do
			5.times{ create_a_point_won_by_player_1 }
			4.times{ create_a_point_won_by_player_2 }
			expect(player_1.game_score(this_game)).to eq('Advantage')
		end
	end

	describe 'games_won' do
		it 'returns the number of games won in this particular set' do
			3.times{ create_a_game_won_by_player_2 }
			expect(player_2.games_won(this_set)).to eq(3)
		end
	end

	describe 'sets_won' do
		it 'returns the number of sets one in this particular match' do
			create_set_won_by_player_1
			expect(player_1.sets_won(match_stats)).to eq(1)
		end
	end

	describe 'begin_point' do
		subject{ player_1.begin_point(point) }

		it 'generates a first_serve' do
			expect{ subject }.to change(FirstServe, :count).by(1)
		end

		it 'returns a hash with the winner and the loser' do
			expect([{ winner: player_1, loser: player_2 }, { winner: player_2, loser: player_1 }]).to include(subject)
		end

		context 'first serve is good' do
			before { allow(FirstServe).to receive(:good?).and_return(true) }

			it 'does not generate a second_serve' do
				expect{ subject }.to_not change(SecondServe, :count)
			end

			it 'generates a return_serve' do
				expect{ subject }.to change(ReturnServe, :count).by(1)
			end

			context 'first_serve is out' do
				before{ allow(FirstServe).to receive(:good?).and_return(false) }

				it 'generates a second_serve' do
					expect{ subject }.to change(SecondServe, :count).by(1)
				end

				context 'second_serve is good' do
					before{ allow(SecondServe).to receive(:good?).and_return(true) }

					it 'generates a return_serve' do
						expect{ subject }.to change(ReturnServe, :count).by(1)
					end
				end

				context 'second_serve is out' do
					before{ allow(SecondServe).to receive(:good?).and_return(false) }

					it 'does not generate a return_serve' do
						expect{ subject }.to_not change(ReturnServe, :count)
					end

					xit 'the server loses the point' do
					end
				end
			end
		end
	end

	describe 'return_serve' do
		subject{ player_2.return_serve(point) }
		before { allow_any_instance_of(PlayerStats).to receive(:continue_rally).and_return({ winner: 'some player', loser: 'some other player' }) }

		it 'creates a new instance of ReturnServe' do
			expect{ subject }.to change(ReturnServe, :count).by(1)
		end

		context 'return_serve is good' do
			before { allow(ReturnServe).to receive(:good?).and_return(true) }

			it 'continues the rally' do
				expect(subject).to eq({ winner: 'some player', loser: 'some other player' })
			end
		end

		context 'return_serve is out' do
			before { allow(ReturnServe).to receive(:good?).and_return(false) }

			it 'does not continue the rally' do
				expect(subject).to_not eq({ winner: 'some player', loser: 'some other player'})
			end

			it 'the player who hits it out loses the point' do
				expect(subject).to eq({ winner: player_1, loser: player_2 })
			end
		end
	end

	describe 'continue_rally' do
		subject{ player_1.continue_rally(point) }
		before{ allow_any_instance_of(PlayerStats).to receive(:winner_and_loser_determined).and_return({ winner: 'some guy', loser: 'some other guy' }) }

		it 'creates a new instance of GeneralPlayShot' do
			expect{ subject }.to change(GeneralPlayShot, :count).by(1)
		end

		it 'returns the winner and loser of the point' do
			expect(subject).to eq({ winner: 'some guy', loser: 'some other guy' })
		end

		it 'continues to create new instances of shots until someone wins the point' do
			allow_any_instance_of(PlayerStats).to receive(:winner_and_loser_determined).and_return(nil, nil, nil, { winner: 'this dude', loser: 'that dude' })
			expect{ subject }.to change(GeneralPlayShot, :count).by(4)
		end

	end
end




