class FiltersController < ApplicationController
  before_action :set_filter, only: %i[ show edit update destroy query]

  # GET /filters or /filters.json
  def index
    @filters = Filter.all
  end

  # GET /filters/1 or /filters/1.json
  def show
  end

  # GET /filters/new
  def new
    @filter = Filter.new
  end

  # GET /filters/1/edit
  def edit
  end

  # POST /filters or /filters.json
  def create
    @filter = Filter.new(filter_params)

    respond_to do |format|
      if @filter.save
        format.html { redirect_to query_filter_url(@filter), notice: "Filter was successfully created." }
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
        format.html { redirect_to filter_url(@filter), notice: "Filter was successfully updated." }
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
      format.html { redirect_to filters_url, notice: "Filter was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def query
    params[:query] ||= @filter.query
    @sum = Hash.new(0)
    @filters = {}
    unless params[:query].blank?
      params[:query].each do |query|
        key = query.first
        search_value = query.last
        unless search_value.blank? 
          field = Field.find(key)
          if field.is_numeric
            if search_value.to_i.zero?
              # TODO : Beware of SQL Injection
              sql = "CAST(data AS INTEGER) #{search_value}"
            else
              sql = "data = ?", search_value
            end
          elsif field.Date?
            start_date = query.last['start']
            end_date = query.last['end'].blank? ? start_date : query.last['end']
            unless start_date.blank?
              sql = "DATE(data) BETWEEN ? AND ? ", start_date, end_date
            end
          else
            sql = "data ILIKE ? ", search_value
          end
          @filters[key] = @filter.table.values.where(field_id: key.to_i).where(sql).pluck(:record_index)
        end
      end
      @filter.update(query: params[:query])
    end

    @records = @filters.values.reduce(:&)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filter
      @filter = Filter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def filter_params
      params.require(:filter).permit(:name, :table_id, :query)
    end
end
