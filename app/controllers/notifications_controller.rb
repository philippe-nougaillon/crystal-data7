class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[ show edit update destroy ]
  before_action :is_user_authorized?
  before_action :set_fields

  # GET /notifications or /notifications.json
  def index
    @notifications = current_user.notifications
  end

  # GET /notifications/1 or /notifications/1.json
  def show
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit
  end

  # POST /notifications or /notifications.json
  def create
    @notification = Notification.new(notification_params)
    @notification.table_id = Field.find(@notification.field_id).table_id
    @notification.user_id = current_user.id

    respond_to do |format|
      if @notification.save
        format.html { redirect_to notifications_url, notice: "Notification créée avec succès." }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1 or /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to notifications_url, notice: "Notification modifiée avec succès." }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    @notification.destroy!

    respond_to do |format|
      format.html { redirect_to notifications_url, notice: "Notification supprimée avec succès." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    def set_fields
      tables_ids = []
      tables = current_user.tables.each do |table|
        tables_ids << table.id if table.propriétaire?(current_user)
      end
      tables = Table.where(id: tables_ids).ordered

      @fields = Field.where(table_id: tables.pluck(:id))
    end

    # Only allow a list of trusted parameters through.
    def notification_params
      params.require(:notification).permit(:table_id, :field_id, :value, :send_to)
    end

    def is_user_authorized?
      authorize @notification? @notification : Notification
    end
end
