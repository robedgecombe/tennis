class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :energy, default: 200
      t.integer :game_score, default: 0
      t.integer :set_score, default: 0
      t.integer :match_score, default: 0
      t.integer :opponent_game_score, default: 0
      t.integer :opponent_set_score, default: 0
      t.integer :opponent_match_score, default: 0
      t.integer :advantage_server_points, default: 0
      t.integer :advantage_receiver_points, default: 0
      t.integer :confidence
      t.integer :concentration
      t.integer :intellegence
      t.integer :power
      t.integer :speed
      t.integer :backhand
      t.integer :accuracy
      t.integer :net_ability
      t.integer :drop_shot
      t.integer :first_serve
      t.integer :second_serve
      t.integer :return

      t.timestamps
    end
  end
end
