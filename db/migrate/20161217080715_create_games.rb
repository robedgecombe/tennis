class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
    	t.integer :set_id
    	t.integer :number
    	t.integer :winner_id
    	t.integer :loser_id
    	t.integer :server_id
    	t.string :status
    	t.datetime :start_time
    	t.datetime :end_time
    end
  end
end
