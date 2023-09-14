# encoding: utf-8

class FieldsController < ApplicationController
  before_action :set_field, only: [:edit, :update, :destroy]
  before_action :is_user_authorized?

  # GET /fields/1/edit
  def edit
    @fields = Field.datatypes.keys.to_a
  end

  # POST /fields
  # POST /fields.json
  def create
    @field = Field.new(field_params)

    respond_to do |format|
      if @field.save
        # Remplir le nouveau champs de vide....   
        @field.table.size.times do |index|
          @field.values.create(record_index: (index + 1))
        end   
        format.html { redirect_to show_attrs_path(id: @field.table.slug), notice: 'Nouvelle colonne ajoutée.' }
        format.json { render :show, status: :created, location: @field }
      else
        format.html { redirect_to show_attrs_path(id: @field.table.slug), alert: 'Veuillez donner un nom à cette colonne' }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fields/1
  # PATCH/PUT /fields/1.json
  def update
    respond_to do |format|
      if @field.update(field_params)
        format.html { redirect_to show_attrs_path(id: @field.table.slug), notice: 'Colonne modifiée avec succès.' }
        format.json { render :show, status: :ok, location: @field }
      else
        format.html { render :edit }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fields/1
  # DELETE /fields/1.json
  def destroy
    @table = @field.table
    @table.values.where(field_id:@field.id).destroy_all
    @field.destroy
    respond_to do |format|
      format.html { redirect_to show_attrs_path(id: @field.table), notice: 'Colonne supprimée.' }
      format.json { head :no_content }
    end
  end

  def update_row_order
    @field = Field.find(field_params[:field_id])
    @field.row_order_position = field_params[:row_order_position]
    @field.save

    #redirect_to show_attrs_path(id:@field.table)
    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_field
      @field = Field.find_by(slug: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def field_params
      params.require(:field).permit(:name, :table_id, :datatype, :filtre, :items, :obligatoire, :operation, :field_id, :row_order_position, :visibility)
    end

    def is_user_authorized?
      if ['create'].include?(action_name)
        @field = Field.new(field_params)
      end
      authorize @field
    end
end
