require 'rails_helper'

describe MatchStats, type: :Model do

	before do
		match.start_match
	end

	let(:match) { create(:match) }
	let(:match_stats) { match.match_stats }
	let(:player_1) { match_stats.player_1 }
	let(:player_2) { match_stats.player_2 }

	def create_one_incomplete_game
		this_set = match_stats.sets.create(status: 'in progress', number: 1)
		this_set.games.create(status: 'in progress', server_id: match_stats.player_2.id)
	end

	def create_one_complete_game
		this_set = match_stats.sets.create(status: 'in progress', number: 1)
		this_set.games.create(status: 'complete', winner_id: match_stats.player_2.id, server_id: match_stats.player_2.id)
	end

	def create_one_complete_set(player, number)
		complete_set = match_stats.sets.create(status: 'in progress', number: number)
		complete_set.games.create(status: 'complete', server_id: player.id, winner_id: player.id, loser_id: player.opponent.id)
		complete_set.games.create(status: 'complete', server_id: player.opponent.id, winner_id: player.id, loser_id: player.opponent.id)
		complete_set.games.create(status: 'complete', server_id: player.id, winner_id: player.id, loser_id: player.opponent.id)
		complete_set.games.create(status: 'complete', server_id: player.opponent.id, winner_id: player.id, loser_id: player.opponent.id)
		complete_set.games.create(status: 'complete', server_id: player.id, winner_id: player.id, loser_id: player.opponent.id)
		complete_set.games.create(status: 'complete', server_id: player.opponent.id, winner_id: player.id, loser_id: player.opponent.id)
		complete_set.update_attributes(winner_id: player.id, loser_id: player.opponent.id, status: 'complete')
	end

	def create_a_set_that_goes_to_tiebreak(number)
		incomplete_set = match_stats.sets.create(status: 'in progress', number: number)
		6.times { incomplete_set.games.create(status: 'complete', server_id: player_1.id, winner_id: player_1.id, loser_id: player_2.id) }
		6.times { incomplete_set.games.create(status: 'complete', server_id: player_2.id, winner_id: player_2.id, loser_id: player_1.id) }
	end

	describe 'play_point' do
		subject{ match_stats.play_point }

		it 'creates a new point' do
			expect{ subject }.to change(Point, :count).by(1)
		end

		it 'is won by somebody' do
			subject
			point = Point.last
			expect(point.winner).to_not be nil
		end

		it 'calls watch_the_point on the point it just created' do
			expect_any_instance_of(Point).to receive(:watch_the_point)
			subject
		end

		context 'it is the start of the match' do
			it 'creates a new set' do
				expect{ subject	}.to change(MatchSet, :count).by(1)
			end

			it 'creates a new game' do
				expect{	subject	}.to change(Game, :count).by(1)
			end

			it 'creates a new point' do
				expect{ subject }.to change(Point, :count).by(1)
			end
		end

		context 'we are in the first set' do
			before do
				create_one_complete_game
			end

			it 'does not create a new set' do
				expect{	subject	}.to_not change(MatchSet, :count)
			end
			
			context 'we are not starting a new game' do
				before do
					match_stats.play_point
				end

				it 'does not create a new game' do
					expect{	subject	}.to_not change(Game, :count)
				end

				it 'creates a new point' do
					expect{ subject }.to change(Point, :count).by(1)
				end
			end

			context 'we are starting a new game' do
				it 'does create a new game' do
					create_one_complete_game
					expect{	subject	}.to change(Game, :count).by(1)
				end

				it 'creates a new point' do
					expect{ subject }.to change(Point, :count).by(1)
				end
			end

		end

		context 'we are starting a new tiebreak' do
			before { create_a_set_that_goes_to_tiebreak(1) }

			it 'creates a new tiebreak' do
				expect{ subject }.to change(Tiebreak, :count).by(1)
			end

			it 'does not create a new game' do
				expect{ subject }.to_not change(Game, :count)
			end

			it 'creates a new point' do
				expect{ subject }.to change(Point, :count).by(1)
			end
		end
	end

	describe 'current_server' do
		subject{ match_stats.current_server }

		context 'we are starting a new match' do
			it 'returns one of the two players, at random' do
				expect([player_1.name, player_2.name]).to include(subject.name)
			end
		end

		context 'we are in the middle of a game' do
			it 'returns the server of that game' do
				create_one_incomplete_game
				expect(subject).to eq(player_2)
			end
		end

		context 'we are starting a new game, in the middle of a set' do
			it 'returns the person who did not serve last' do
				create_one_complete_game
				expect(subject).to eq(player_1)
			end
		end

		context 'we are starting a new set' do
			it 'returns the person who did not serve the last game of the last set' do
				create_one_complete_set(player_1, 1)
				expect(subject).to eq(player_2)
			end
		end
	end

	describe 'get_tiebreak_server' do
		subject{ match_stats.get_tiebreak_server }

		before do
			create_a_set_that_goes_to_tiebreak(1)
		end

		context 'we are starting a new tiebreak' do
			it 'returns one of the two players, at random' do
				expect([player_1.name, player_2.name]).to include(subject.name)
			end
		end

		context 'we are in the middle of a tiebreak' do
			context 'we have had an odd number of points' do
				it 'returns the person who did not serve the most recent point' do
					match_stats.play_point
					last_server = Point.last.server
					expect(subject).to eq(last_server.opponent)
				end
			end

			context 'we have had an even number of points' do
				it 'returns the person who did server the most recent point' do
					2.times{ match_stats.play_point }
					last_server = Point.last.server
					expect(subject).to eq(last_server)
				end
			end
		end
	end

	describe 'complete?' do
		subject{ match_stats.complete? }

		context 'player_1 has won two sets' do
			it 'returns true' do
				create_one_complete_set(player_1, 1)
				create_one_complete_set(player_1, 1)
				expect(subject).to be true
			end
		end

		context 'player_2 has won two sets' do
			it 'returns true' do
				create_one_complete_set(player_2, 1)
				create_one_complete_set(player_2, 2)
				expect(subject).to be true
			end
		end

		context 'neither player has won two sets' do
			it 'returns false' do
				create_one_complete_set(player_1, 1)
				create_one_complete_set(player_2, 2)
				expect(subject).to be false
			end
		end
	end
end