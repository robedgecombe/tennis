class CreateShots < ActiveRecord::Migration
  def change
    create_table :shots do |t|
    	t.integer :hitter_id, null: false
    	t.integer :receiver_id, null: false
    	t.integer :point_id, null: false
        # t.string :name
    	t.string :type
        t.string :hand
        t.decimal :x_axis_location_on_contact, precision: 5, scale: 2
        t.decimal :y_axis_location_on_contact, precision: 5, scale: 2
        t.decimal :ball_height_on_contact, precision: 5, scale: 2
        t.integer :horizontal_ball_direction_on_contact
        t.integer :vertical_ball_direction_on_contact
        t.float :ball_speed_on_contact
        t.string :spin_direction_on_contact
        t.float :spin_revolutions_per_second_on_contact
        t.float :body_position_control_percentage
        t.float :racket_sweet_spot_percentage
        t.float :energy_towards_spin
        t.float :energy_towards_power
        t.float :energy_towards_placement
        t.string :attempted_location
        t.string :attempted_spin_direction
    	t.boolean :good
    	t.boolean :winner, default: false
    end
  end
end
