class Player < ActiveRecord::Base
	validates :name, :energy, presence: true
end
