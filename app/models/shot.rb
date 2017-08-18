class Shot < ActiveRecord::Base
	belongs_to :point
	belongs_to :hitter, class_name: 'PlayerStats'
	belongs_to :receiver, class_name: 'PlayerStats'

	delegate :game, :tiebreak, :set, :match_stats, to: :point
	# delegate :tiebreak, to: :point

	validates :hitter_id, presence: true
	validates :receiver_id, presence: true
	validates :point_id, presence: true

	TYPES = %w(FirstServe SecondServe ReturnServe GeneralPlayShot)
  before_save :set_type
  validates :type, presence: true, :inclusion => { :in => TYPES }

  def self.good?
		# implement at a lower level, my friend
  end

end