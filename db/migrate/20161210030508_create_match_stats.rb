class CreateMatchStats < ActiveRecord::Migration
  def change
    create_table :match_stats do |t|
    	t.integer :match_id, null: false
    	t.integer :player_1_stats_id, null: false
      t.integer :player_2_stats_id, null: false
    	t.datetime :start_time
    	t.datetime :end_time
    end
  end
end
