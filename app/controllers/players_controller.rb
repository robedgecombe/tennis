class PlayersController < ApplicationController
	respond_to :html

	def player_params
  	params.require(:player).permit(:name, :power, :speed, :intelligence, :confidence, :concentration, :accuracy, :first_serve, :second_serve, :backhand, :drop_shot, :net_ability, :return)
	end

	def index
		@players = Player.all
	end

	def new
		@skill_set = random_initial_attributes
		@player = Player.new(@skill_set)
	end

	def create
		@player = Player.new(params[:player])
		if @player.save
			redirect_to action: :index
		else
			@skill_set = params[:player]
			@skill_set.shift
			respond_with(@player)
		end
	end

	def edit
		@player = Player.find(params[:id])
	end

	def show
		"hi show"
		binding.pry
		"yep hi show"
	end

private

	def random_initial_attributes
		attributes = Hash[Player::SKILLS.zip Player::SKILLS_RANKING.shuffle]
		attributes.sort_by{|key, value| value}.to_h
	end
end