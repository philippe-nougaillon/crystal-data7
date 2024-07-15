class PagesController < ApplicationController
  before_action :info_notice, only: %i[graphs]
  skip_before_action :authenticate_user!, only: %i[a_propos]

  def a_propos
  end

  def graphs
    @tables = current_user.tables.order(:name)
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

  def assistant
    @prompts = current_user.prompts.order(created_at: :desc)

    if params[:table_id].present? && params[:prompt].present? && params[:commit].present?
      if table = current_user.tables.find_by(id: params[:table_id])
        prompt = params[:prompt]
        query, fields = prompt.split(': [')
        fields = fields.split(']').first.split(', ')
        correct_fields = true
        fields.each do |field|
          unless table.fields.pluck(:name).include?(field)
            correct_fields = false
            break
          end
        end
        if correct_fields
          values = table.values_at(fields)
          query_with_collection_values = query.split(': [').first + ' : ' + values 
          
          llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
          @results = llm.chat(messages: [{role: "user", content: query_with_collection_values }]).completion

        else
          @results = "Désolé je ne comprends pas votre question. Merci de vérifier les attributs."
        end
        Prompt.create(user_id: current_user.id, table_id: table.id, query: prompt, response: @results)
      end
    end
  end

  private

  def info_notice
    if current_user.compte_démo? && flash[:notice] == nil && flash[:alert] == nil && params.keys.size == 2
      flash[:notice] = "(i)Les graphiques permettent de visualiser une série de valeurs issues de vos collections"
    end
  end
  
end
