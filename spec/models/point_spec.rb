require 'rails_helper'

describe Point, type: :Model do
	before do
		match.start_match
	end

	let(:match) { create(:match) }
	let(:match_stats) { match.match_stats }
	let(:this_set) { match_stats.sets.create(status: 'in progress', number: 1) }
	let(:this_game) { this_set.games.create(status: 'in progress', server_id: match_stats.player_2.id) }
	let(:point) { this_game.points.create(status: 'in progress', server_id: this_game.server_id) }

	describe 'watch_the_point' do
		subject{ point.watch_the_point(match_stats.player_1) }

		it 'has a winner' do
			subject
			expect(point.winner.class).to eq(PlayerStats)
		end

		it 'has a loser' do
			subject
			expect(point.loser.class).to eq(PlayerStats)
		end

		it 'the winner is the the same person as the loser' do
			subject
			expect(point.winner).to_not eq(point.loser)
		end

		it 'completes the point' do
			subject
			expect(point.status).to eq('complete')
		end

		it 'calls check_status on the game it is in' do
			expect(this_game).to receive(:check_status)
			subject
		end
	end
end