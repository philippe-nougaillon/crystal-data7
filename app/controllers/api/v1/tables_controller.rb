# encoding: utf-8

module Api
	module V1
		class TablesController < ActionController::Base

			def index
				user = User.find_by(id: params[:user_id])
				render json: user ? user.tables : []
			end
		end
	end
end