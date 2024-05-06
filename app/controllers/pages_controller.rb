class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[a_propos]
  before_action :info_notice, only: %i[stats]

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

          if field.Euros? || field.Nombre?
            @results = @values.pluck(:record_index, :data).to_h
            results_humanized = {}
            @results.each do |k, v|
              label = @table.values.records_at(k).pluck(:data).first(2)
              results_humanized[label.insert(0,k)] = v
            end
            @results = results_humanized
          elsif field.Collection?
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

  private

  def info_notice
    if current_user.compte_démo? && flash[:notice] == nil && flash[:alert] == nil && params.keys.size == 2
      flash[:notice] = "(i)Les statistiques permettent de visualiser une série de valeurs issues de vos collections"
    end
  end
  
end
