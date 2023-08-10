# encoding: utf-8

module Api
	module V1
		class Api::V1::TablesController < ActionController::Base

			def index
				render json: User.find(params[:user_id]).tables
			end
		end
	end

end