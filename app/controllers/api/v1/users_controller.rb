# encoding: utf-8

module Api
	module V1
		class Api::V1::UsersController < ActionController::Base

			def index
				@users = User.all
				render json: @users
			end

			def timestamps
				unless params[:user_id]
					timestamps = {}
					timestamps['Name'] = "users"
					timestamps['TimeStampValue'] = User.maximum(:updated_at).to_i
					render json: timestamps
				else
					array_of_timestamps = [
						{:Name => 'tables', :TimeStampValue => Table.maximum(:updated_at).to_i}, 
						{:Name => 'fields', :TimeStampValue => Field.maximum(:updated_at).to_i}
					]
					render json: array_of_timestamps
				end
			end
		end
	end
end