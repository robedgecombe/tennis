class FirstServe < Shot
	def set_type
    self.type = 'FirstServe'
  end

  def self.good?
  	random_number = rand(10)
		random_number <= 4 ? true : false
  end
end