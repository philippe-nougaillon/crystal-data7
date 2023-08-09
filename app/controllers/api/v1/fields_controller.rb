# encoding: utf-8

class API::V1::FieldsController < ApplicationController

	def index
		render json: Table.find_by(slug: params[:slug]).fields
	end

end