class FiltersController < ApplicationController
  before_action :set_filter, only: %i[ show edit update destroy query]
  before_action :is_user_authorized?
  before_action :info_notice, only: %i[index query]

  # GET /filters or /filters.json
  def index
    @filters = current_user.organisation.filters.ordered
  end

  # GET /filters/1 or /filters/1.json
  def show
  end

  # GET /filters/new
  def new
    @filter = Filter.new
    @teams = current_user.organisation.teams
  end

  # GET /filters/1/edit
  def edit
  end

  # POST /filters or /filters.json
  def create
    @filter = Filter.new(filter_params)
    @filter.user_id = current_user.id

    respond_to do |format|
      if @filter.save
        format.html { redirect_to query_filter_url(@filter)}
        format.json { render :show, status: :created, location: @filter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /filters/1 or /filters/1.json
  def update
    respond_to do |format|
      if @filter.update(filter_params)
        format.html { redirect_to filter_url(@filter), notice: t('notice.filter.updated') }
        format.json { render :show, status: :ok, location: @filter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filters/1 or /filters/1.json
  def destroy
    @filter.destroy

    respond_to do |format|
      format.html { redirect_to filters_url, notice: t('notice.filter.destroyed') }
      format.json { head :no_content }
    end
  end

  def query
    params["[query]"] ||= @filter.query
    if current_user.compte_démo? && !Rails.env.development? 
      flash[:alert] = t('notice.user.demo_not_authorized')
    else
      @filter.update(query: params["[query]"])
    end
    @records = @filter.get_filtered_records

    if params[:sort_by]
      # ordre de tri ASC/DESC
      order_by = (params[:sort_by] == session[:sort_by]) ? ((session[:order_by] == "DESC") ? "ASC" : "DESC") : "ASC"
      
      if params[:sort_by] == '0'
        @records = @filter.table.values.records_at(@records).order("values.updated_at #{order_by}").pluck(:record_index).uniq
      elsif ['Euros', 'Nombre', 'Formule'].include?(Field.find(params[:sort_by]).datatype)
        @records = @filter.table.values.records_at(@records)
                        .where(field_id: params[:sort_by])
                        .order(Arel.sql("CAST(data AS float8) #{order_by}"))
                        .pluck(:record_index)
      else
        @records = @filter.table.values.records_at(@records)
                                .where(field_id: params[:sort_by])
                                .order("data #{order_by}")
                                .pluck(:record_index)
      end
      
      session[:sort_by] = params[:sort_by]
      session[:order_by] = order_by
    end

    respond_to do |format|
      format.html do
        @sum = Hash.new(0)
      end

      format.xls do
        book = CollectionToXls.new(@filter.table, @records).call
        file_contents = StringIO.new
        book.write file_contents # => Now file_contents contains the rendered file output
        filename = "Export collection d'objets '#{@filter.table.name}' du_#{Date.today.to_s}.xls"
        send_data file_contents.string.force_encoding('binary'), filename: filename 
      end
      
      format.csv do
        csv_string = CollectionToCsv.new(@filter.table, @records).call
        filename = "Export collection d'objets '#{@filter.table.name}' du_#{Date.today.to_s}.csv"
        send_data csv_string, filename: filename
      end
      format.pdf do
        pdf = ExportPdf.new
        pdf.export_collection(@filter.table, @records)
        filename = "Export_#{@filter.table.name}.pdf"
        
        send_data pdf.render, filename: filename, type: 'application/pdf'
      end
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filter
      @filter = Filter.find_by(slug: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def filter_params
      params.require(:filter).permit(:name, :table_id, :query)
    end

    def is_user_authorized?
      authorize @filter? @filter : Filter
    end

    def info_notice
      if current_user.compte_démo? && flash[:notice] == nil && flash[:alert] == nil
        flash[:notice] = case params[:action]
        when 'index'
          t('notice.field.index')
        when 'query'
          if params.keys.count == 3 # ne pas afficher l'aide quand on applique la requête
            t('notice.filter.query')
          end
        end
      end
    end
end
