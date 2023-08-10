# encoding: utf-8

module Api
	module V1
		class Api::V1::ValuesController < ActionController::Base
	
			protect_from_forgery with: :null_session

			def index
				render json: Table.find_by(slug: params[:slug]).values.reorder(:record_index)
			end

			def post_value
				@value = Value.new(value_params)
				@table = @value.table
				record_index = @table.size + 1

				@value.record_index = record_index

				if @value.field_id == @table.fields.last.id
					@table.update_attributes(record_index: record_index)
				end

				respond_to do |format|
					if @value.save
						format.json { render json: @value, status: :created, location: @value }
					else
						format.json { render json: @value.errors, status: :unprocessable_entity }
					end
				end
			end

private
			# Use callbacks to share common setup or constraints between actions.
			def set_value
				@value = Value.find(params[:id])
			end

			# Never trust parameters from the scary internet, only allow the white list through.
			def value_params
				params.require(:value).permit(:user_id, :field_id, :table_id, :data)
			end
		end
	end
end