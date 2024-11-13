class PagesController < ApplicationController
  before_action :info_notice, only: %i[graphs]
  before_action :user_authorized?
  skip_before_action :authenticate_user!, only: %i[a_propos mentions_legales]

  def a_propos
  end

  def graphs
    @tables = current_user.tables.order(:name)
    @results = Hash.new
    params[:type] ||= 'line'

    if params[:collection_id].present?
      @table = Table.find(params[:collection_id])
      @column_names = @table.fields
      @types = ['bar','line','pie','scatter', 'doughnut','polarArea', 'radar'] # bubble / mixed pas implémentés
      @filters = @table.filters

      if params[:attribut_id].present?
        if field = @table.fields.find_by(id: params[:attribut_id])
          @values = field.values
          if params[:filtre].present?
            @values = @values.where(record_index: @table.filters.find_by(slug: params[:filtre]).get_filtered_records)
          end
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
        
        if params[:sort].present?
          if params[:order] == 'asc'
            @results = @results.sort_by { |_, v| v }.to_h
          else 
            @results = @results.sort_by { |_, v| -v }.to_h
          end
        end
      end
    end
  end

  def assistant
    @prompts = current_user.prompts.order(created_at: :desc).limit(10)

    if params[:table_id].present?
      @fields = current_user.tables.find_by(id: params[:table_id]).fields.order(:name)
      if params[:fields_ids].present? && params[:prompt].present? && params[:commit].present?
        if table = current_user.tables.find_by(id: params[:table_id])
          prompt = params[:prompt]
          values = table.values_at(params[:fields_ids])
          query_with_collection_values = prompt + " dans cette liste : " + values + ' ?' 
          
          llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
          @results = llm.chat(messages: [{role: "user", content: query_with_collection_values }]).completion

          Prompt.create(user_id: current_user.id, table_id: table.id, fields_id: params[:fields_ids], query: prompt, response: @results)
        end
      end
    end
  end

  def mentions_legales
  end

  def dashboard
    @graphs = current_user.organisation.graphs
    @results = []

    @graphs.each_with_index do |graph, i|
      @results[i] = Hash.new
      field = graph.field
      @values = field.values
      if graph.filter
        @values = @values.where(record_index: graph.filter.get_filtered_records)
      end
      # Stocke le nombre d'occurence pour chaque valeur
      # TODO: Avec un champ ajouté à graph, il faut récupérer les records_index pour dire que tel value va dans tel groupe
      @results[i] = @values.group(:data).order(:data).count(:id)

      if field.Euros? || field.Nombre?
        if !graph.group
          @results[i] = @values.pluck(:record_index, :data).to_h
        end
        results_humanized = {}
        @results[i].each do |k, v|
          # label = graph.table.values.records_at(k).pluck(:data).first(2)
          results_humanized[k] = v
        end
        @results[i] = results_humanized
      elsif field.Collection?
        results_humanized = {}
        @results[i].each do |k, v|
          results_humanized[field.get_linked_table_record(k)] = v
        end
        @results[i] = results_humanized
      elsif field.Signature?
        results_humanized = {'Pas signé' => 0, 'Signé' => 0}
        @results[i].each do |k, v|
          if k.blank?
            results_humanized['Pas signé'] += v
          else
            results_humanized['Signé'] += v
          end
        end
        @results[i] = results_humanized
      end

      if graph.sort
        if graph.desc
          @results[i] = @results[i].sort_by { |_, v| -v }.to_h
        else 
          @results[i] = @results[i].sort_by { |_, v| v }.to_h
        end
      end
    end
    
  end

  private

  def user_authorized?
    authorize :pages
  end

  def info_notice
    if current_user.compte_démo? && flash[:notice] == nil && flash[:alert] == nil && params.keys.size == 2
      flash[:notice] = t('notice.graph')
    end
  end
end
