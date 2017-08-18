# require 'rails_helper'

# describe PlayersController do

# 	let(:valid_params) { { name: "Bob",
# 												power: 8,
# 												speed: 3,
# 												intelligence: 9,
# 												confidence: 6,
# 												concentration: 5,
# 												accuracy: 4,
# 												first_serve: 7,
# 												second_serve: 2,
# 												backhand: 1,
# 												drop_shot: 10,
# 												net_ability: 11,
# 												return: 12
# 											} }
# 	let(:invalid_params) { { name: "Bill",
# 													power: 1,
# 													speed: 2,
# 													intelligence: 3,
# 													confidence: 4,
# 													concentration: 5,
# 													accuracy: 6,
# 													first_serve: 7,
# 													second_serve: 8,
# 													backhand: 9,
# 													drop_shot: 10,
# 													net_ability: 10,
# 													return: 11
# 													}}

# 	describe "GET index" do
# 		it "renders" do
# 			get :index
# 			expect(response).to be_success
# 			expect(response).to render_template(:index)
# 		end
# 	end

# 	describe "GET new" do
# 		it "assigns a new new player" do
# 			get :new
# 			expect(response).to be_success
# 		end
# 	end

# 	describe "POST create" do
# 		context "with valid params" do
# 			subject{ post :create, player: valid_params }
# 			it "creates a new player" do
# 				expect{
# 					subject
# 				}.to change(Player, :count).by(1)
# 			end
# 		end

# 		context "with invalid params" do
# 			subject{ post :create, player: invalid_params }
# 			it "does not create a new player" do
# 				expect{
# 					subject
# 				}.to_not change(Player, :count)
# 			end

# 			it "re-renders the 'new' template" do
# 				subject
# 				expect(response).to render_template(:new)
# 			end
# 		end
# 	end

# end