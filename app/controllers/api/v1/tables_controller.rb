# encoding: utf-8

class API::V1::TablesController < ApplicationController

	def index
		render json: User.find(params[:user_id]).tables
	end

end