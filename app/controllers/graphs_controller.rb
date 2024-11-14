class GraphsController < ApplicationController
  before_action :set_graph, only: %i[ show edit update destroy ]
  before_action :is_user_authorized?
  before_action :set_form_variables, only: %i[ new edit ]

  # GET /graphs or /graphs.json
  def index
    @graphs = current_user.organisation.graphs.ordered
  end

  # GET /graphs/1 or /graphs/1.json
  def show
  end

  # GET /graphs/new
  def new
    @graph = Graph.new
  end

  # GET /graphs/1/edit
  def edit
  end

  # POST /graphs or /graphs.json
  def create
    @graph = Graph.new(graph_params)
    @graph.organisation_id = current_user.organisation_id

    respond_to do |format|
      if @graph.save
        format.html { redirect_to graphs_path, notice: t('notice.graph.new') }
        format.json { render :show, status: :created, location: @graph }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /graphs/1 or /graphs/1.json
  def update
    respond_to do |format|
      if @graph.update(graph_params)
        format.html { redirect_to graphs_path, notice: t('notice.graph.updated') }
        format.json { render :show, status: :ok, location: @graph }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /graphs/1 or /graphs/1.json
  def destroy
    @graph.destroy!

    respond_to do |format|
      format.html { redirect_to graphs_path, status: :see_other, notice: t('notice.graph.destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_graph
      @graph = Graph.find(params[:id])
    end

    def set_form_variables
      @tables = current_user.tables
      @fields = current_user.fields
      @filters = current_user.filters
      @types = ['bar','line','pie','scatter', 'doughnut','polarArea', 'radar'] # bubble / mixed pas implémentés
    end

    # Only allow a list of trusted parameters through.
    def graph_params
      params.require(:graph).permit(:field_id, :filter_id, :name, :chart_type, :sort, :desc, :group)
    end

    def is_user_authorized?
      authorize @graph ? @graph : Graph
    end
end
