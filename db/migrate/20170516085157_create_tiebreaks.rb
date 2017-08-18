class CreateTiebreaks < ActiveRecord::Migration
  def change
    create_table :tiebreaks do |t|
    	t.integer :set_id
    	t.integer :winner_id
    	t.integer :loser_id
    	t.string :status
    	t.datetime :start_time
    	t.datetime :end_time
    end
  end
end
