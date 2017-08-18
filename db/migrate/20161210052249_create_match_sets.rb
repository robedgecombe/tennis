class CreateMatchSets < ActiveRecord::Migration
  def change
    create_table :match_sets do |t|
    	t.integer :match_stats_id, null: false
    	t.integer :number
    	t.integer :winner_id
    	t.integer :loser_id
    	t.string  :status
    	t.datetime :start_time
    	t.datetime :end_time
    end
  end
end
