class MatchSerializer < ActiveModel::Serializer

	attributes :id, :players
	has_many :players	

end