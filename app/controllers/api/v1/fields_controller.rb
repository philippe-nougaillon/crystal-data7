# encoding: utf-8

module Api
	module V1
		class FieldsController < ActionController::Base

			def index
				table = Table.find_by(slug: params[:slug])
				render json: table ? table.fields : []
			end
		end
	end
end