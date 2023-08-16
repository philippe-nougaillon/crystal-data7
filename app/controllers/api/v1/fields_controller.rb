# encoding: utf-8

module Api
	module V1
		class Api::V1::FieldsController < ActionController::Base

			def index
				render json: Table.find_by(slug: params[:slug]).fields
			end
		end
	end
end