class MatchesController < ApplicationController


	def index
		@matches = Match.all
	end

	def create
		@match = Match.create
		id = @match.id
		@match = Match.find(id)
		respond_to do |format|
			format.json {render json: @match}			
		end
	end

	def show
		@match = Match.find(params[:id])

		respond_to do |format|
			format.html { render :show}
			format.json { render json: @match }
		end
	end

end