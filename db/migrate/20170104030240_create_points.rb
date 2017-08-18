class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
    	t.integer :game_id
    	t.integer :tiebreak_id
    	t.integer :winner_id
    	t.integer :loser_id
    	t.integer :server_id
    	t.string :status
    	t.datetime :start_time
    	t.datetime :end_time
    end
  end
end
