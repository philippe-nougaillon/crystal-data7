class ValuesController < ApplicationController
  # before_action :set_value, only: []
  before_action :is_user_authorized?

  def signature
    @table = Table.find(params[:table])
    @signature = @table.values.records_at(params[:record_index]).find_by(field_id:params[:field]).data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_value
      @value = Value.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def value_params
      params.require(:value).permit(:field_id, :table_id, :data)
    end

    def is_user_authorized?
      @value = Table.find(params[:table]).values.records_at(params[:record_index]).find_by(field_id:params[:field])
      authorize @value
    end
end
