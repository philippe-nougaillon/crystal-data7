class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def a_propos
  end

  def stats
    @tables = current_user.tables
    @results = Hash.new

    if params[:collection_id].present?
      @table = Table.find(params[:collection_id])
      @column_names = @table.fields

      if params[:attribut_id].present?
        if field = @table.fields.find_by(id: params[:attribut_id])        
          @values = field.values
          @results = @values.group(:data).order(:data).count(:id)
        end
      end
    end
  end
  
end
