class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[a_propos]

  def a_propos
  end

  def stats
    @tables = current_user.tables
    @results = Hash.new
    params[:type] ||= 'line'

    if params[:collection_id].present?
      @table = Table.find(params[:collection_id])
      @column_names = @table.fields

      if params[:attribut_id].present?
        if field = @table.fields.find_by(id: params[:attribut_id])
          @values = field.values
          @results = @values.group(:data).order(:data).count(:id)

          if field.Collection?
            results_humanized = {}
            @results.each do |k, v|
              results_humanized[field.get_linked_table_record(k)] = v
            end
            @results = results_humanized
          elsif field.Signature?
            results_humanized = {'Pas signé' => 0, 'Signé' => 0}
            @results.each do |k, v|
              if k.blank?
                results_humanized['Pas signé'] += v
              else
                results_humanized['Signé'] += v
              end
            end
            @results = results_humanized
          end
        end
      end
    end
  end
  
end
