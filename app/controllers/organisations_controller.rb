class OrganisationsController < ApplicationController
  before_action :set_organisation, only: %i[ show edit update destroy ]
  before_action :is_user_authorized

  # GET /organisations/1 or /organisations/1.json
  def show
  end

  # GET /organisations/1/edit
  def edit
  end

  # PATCH/PUT /organisations/1 or /organisations/1.json
  def update
    respond_to do |format|
      if @organisation.update(organisation_params)
        format.html { redirect_to organisation_url(@organisation), notice: "Organisation was successfully updated." }
        format.json { render :show, status: :ok, location: @organisation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organisation
      @organisation = Organisation.find_by(slug: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organisation_params
      params.require(:organisation).permit(:nom)
    end

    def is_user_authorized
      authorize @organisation ? @organisation : Organisation
    end
end
