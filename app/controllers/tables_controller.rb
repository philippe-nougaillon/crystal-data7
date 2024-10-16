class TablesController < ApplicationController
  before_action :set_table, except: [:new, :create, :import, :import_do, :index, :securite]
  before_action :is_user_authorized?
  before_action :info_notice, only: %i[index show_attrs partages logs securite]
  skip_before_action :authenticate_user!, only: %i[ icalendar fill fill_do ]

  # GET /tables
  # GET /tables.json
  def index
    @tables = current_user.tables.includes(:fields)
  end

  # GET /tables/1
  # GET /tables/1.json
  def show
    unless params[:view].present?
      params[:view] = 'table'
    end

    @sum = Hash.new(0)
    @filters = {}
    @filter_results = {}
    @values = @table.values

    # Limite les enregistrement aux collecteurs
    if @table.collecteur?(current_user)
      @values = @values.where(user_id: current_user.id)
    end

    # recherche les lignes 
    unless params.permit(:search).blank?
      search = "%#{ params[:search].strip }%"
      @values = @values.where("data ILIKE ?", search)
      # Est-ce qu'il y a des Tables liées ?
      @table.fields.Collection.each do | field_table |
        # Rchercher dans les values de ce champ lié si valeurs recherchées
        s = /#{ params[:search].strip }/i
        results = field_table.populate_linked_table.select{|k,v| v.match(s)}
        # Ajouter les clés trouvées
        @values = @values + field_table.values.where(data: results.keys)
      end
    end
    
    @filters[:search] = search
    @filter_results[:search] = @values.pluck(:record_index).uniq

    # Applique les filtres de type SELECT_TAG
    unless params[:select].blank?
      params[:select].each do | option | 
        unless option.last.blank? 
          field = Field.find(option.first)
          if field.Tags?
            filter_records = @table.values.where(field: field).where("values.data ILIKE ?", "%#{option.last}%").pluck(:record_index) 
          else
            filter_records = @table.values.where(field: field, data: option.last).pluck(:record_index) 
          end
          @filters[option.first] = option.last
          @filter_results[option.first] = filter_records
        end
      end
    end

    # Applique les filtres de type DATE
    unless params[:date].blank?
      params[:date].keys.each do | field_id |
        unless params[:date][field_id][:start].blank?
          start_date = params[:date][field_id][:start].blank? ? Date.today : params[:date][field_id][:start]
          end_date = params[:date][field_id][:end].blank? ? start_date : params[:date][field_id][:end]
          field = Field.find(field_id)
          filter_records = @table.values.where(field: field).where("data BETWEEN ? AND ?", start_date, end_date).pluck(:record_index) 
          @filters[field_id] = [start_date, end_date]
          @filter_results[field_id] = filter_records
        end
      end
    end

    if params[:filtre].present?
      @records = @table.filters.find_by(slug: params[:filtre]).get_filtered_records
    else
      @records = @filter_results.values.reduce(:&)
    end

    if @table.lifo 
     # calcule la date maximum de chaque ligne d'enregistrement 
     h = @table.values.select("values.record_index").group("fields.row_order, values.record_index").maximum(:updated_at)
     # inverse le hash (keys <=> values) pour faire un tri par date et retourne les record_index
     @records = Hash[h.sort_by{|k, v| v}.reverse].keys & @records
    end     

    if params[:sort_by]
      # ordre de tri ASC/DESC
      order_by = (params[:sort_by] == session[:sort_by]) ? ((session[:order_by] == "DESC") ? "ASC" : "DESC") : "ASC"
      
      if params[:sort_by] == '0'
        @records = @table.values.records_at(@records).order("values.updated_at #{order_by}").pluck(:record_index).uniq
      else
        @records = @table.values.records_at(@records)
                                .where(field_id: params[:sort_by])
                                .order("data #{order_by}")
                                .pluck(:record_index)
      end
      
      session[:sort_by] = params[:sort_by]
      session[:order_by] = order_by
    end

    case params[:view]
    when 'graph'
      if @table.fields.exists?(datatype: ['Nombre','Euros'])
        @title = @table.fields.where(datatype: ['Nombre','Euros']).first.name
        fields_id = @table.fields.where.not(datatype: ['Nombre','Euros']).first(2).pluck(:id)
        labels = []
        fields_id.each do |field_id|
          datas = @table.values.where(record_index: @records, field_id: field_id).pluck(:data)
          if Field.find(field_id).Date?
            datas = datas.map{ |data| l(data.to_date) }
          end
          labels << datas
        end
        @labels = labels.transpose
      end

    when 'map'
      if @table.fields.exists?(datatype: ['GPS'])
        @data = []
        @lng = []
        @lat = []
        fields_id = @table.fields.where.not(datatype: ['GPS']).first(7).pluck(:id)
        if fields_id.any?
          fields_id.each do |field|
            @data << @table.values.where(record_index: @records, field_id: field).pluck(:data)
          end
          @data = @data.transpose
          gps_values = @table.fields.where(datatype: 'GPS').first.values.where.not(data: [nil, '']).pluck(:data)
          gps_values.each do |gps_value|
            @lng << gps_value.split(',').last.to_f
            @lat << gps_value.split(',').first.to_f
          end
        end
      end
    when 'calendar'
      @date_values = @table.values.joins(:field).where(record_index: @records, 'field.datatype': 'Date')
    end

    respond_to do |format|
      format.html
      format.xls do
        book = CollectionToXls.new(@table, @records).call
        file_contents = StringIO.new
        book.write file_contents # => Now file_contents contains the rendered file output
        filename = "Export_#{@table.name.pluralize}.xls"
        send_data file_contents.string.force_encoding('binary'), filename: filename 
      end
      format.csv do
        csv_string = CollectionToCsv.new(@table, @records).call
        filename = "Export_#{@table.name.pluralize}.csv"
        send_data csv_string, filename: filename
      end
      format.pdf do
        pdf = ExportPdf.new
        pdf.export_collection(@table, @records)
        filename = "Export_#{@table.name.pluralize}.pdf"
        
        send_data pdf.render, filename: filename, type: 'application/pdf'
      end
    end 
  end

  def show_attrs 
    @field = Field.new(table_id: @table.id)
    @fields = Field.datatypes.keys.to_a
  end

  # formulaire d'ajout / modification
  def fill
    if params[:record_index] && user_signed_in?
      # modification ligne existante
      @record_index = params[:record_index]
    else
      # ajout d'une ligne (à laisser négatif ou alors changer le code dans fill_do)
      @record_index = "-1"
    end
  end

  # formulaire d'ajout / modification posté
  def fill_do
    table = Table.find(params[:table_id])
    data = params["[data]"]
    if data.keys.first.to_i.positive? && user_signed_in?
      # update
      record_index = data.keys.first
      values = data[record_index.to_s]
    else 
      # create
      record_index = table.increment_record_index
      values = data["-1"]
    end

    if not values.values.compact_blank.blank?
      # update? = si données existent déjà, on les supprime avant pour pouvoir ajouter les données modifiées 
      update = table.values.where(record_index:record_index).any?
      # garde la date de dernière mise à jour
      created_at_date = table.values.where(record_index:record_index).first.created_at if update

      # quel champ a été modifié ?
      table.fields.each do |field|
        value = values[field.id.to_s]
        if field.obligatoire and value.blank?
          flash[:alert] = t('notice.table.missing_required_field')
          redirect_to action: 'fill', record_index: record_index
          return
        end  

        # test si c'est un update ou new record
        old_value = table.values.find_by(record_index:record_index, field:field)

        # enregistre le fichier
        if field.Fichier? || field.Image? || field.PDF?
          unless value.blank?
            b = Blob.new()
            b.file.attach(value)
            b.save
            value = b.id
            created_at_date = DateTime.now
          else 
            # si l'utilisateur n'a pas choisi de fichier
            # on passe pour ne pas écraser le fichier existant
            next if old_value
          end
        elsif field.Formule? 
          value = field.evaluate(table, record_index) # evalue le champ calculé
        elsif field.QRCode?
          value = field.generate_qrcode(record_index)
        elsif field.Distance?
          value = field.distance(table, record_index)
        end

        if old_value
          if (old_value.data != value) and !(old_value.data.blank? and value.blank?)

            ActiveRecord::Base.transaction do
              # supprimer les anciennes données
              table.values
                    .find_by(record_index:record_index, field:field)
                    .delete

              # enregistrer les nouvelles données
              Value.create(field_id: field.id, 
                            record_index: record_index, 
                            data: value, 
                            old_value: old_value.data,
                            user_id: old_value.user_id,
                            created_at: created_at_date)
            end
          end
        else
          # enregistrer les nouvelles données
          Value.create(field_id: field.id, 
                      record_index: record_index, 
                      data: value,
                      user_id: current_user.try(:id) || 3,
                      created_at: created_at_date,
                      audit_comment: (table.public? && !user_signed_in?) ? 'Anonyme' : nil)

        end

        # envoyer notifications si l'attribut a la valeur attendue
        if !old_value || (old_value.data != value)
          if notifications = table.notifications.where(field_id: field.id, value: value)
            notifications.each do |notification|
              notification.update!(last_notif_sent_at: DateTime.now)
              mailer_response = UserMailer.new_custom_notification(notification, record_index).deliver_now
              MailLog.create(user_id: notification.user_id, message_id: mailer_response.message_id, to: notification.send_to, subject: "Notification '#{table.name.humanize}:#{field.name.humanize}'")
            end
          end
        end

      end

      # notifier l'utilisateur d'un ajout 
      if not update and table.notification
        UserMailer.notification(table, table.value_datas_listable(record_index)).deliver_now
      end

      if params[:relation].present? && params[:value].present?
        table = Table.find(Relation.find(params[:relation]).relation_with_id)
        url = details_path(table.slug, record_index: params[:value])
        redirect_to url, notice: t('notice.value.updated_created', status: update ? 'modifiées' : 'ajoutées')
      elsif user_signed_in?
        redirect_to table, notice: t('notice.value.updated_created', status: update ? 'modifiées' : 'ajoutées')
      else
        redirect_to fill_path(table), notice: t('notice.value.updated_created', status: update ? 'modifiées' : 'ajoutées')
      end
    else
      redirect_to table, alert: t('notice.value.no_save')
    end
  end  

  def delete_record
    if params[:record_index]
      record_index = params[:record_index].to_i
      if @table.record_can_be_destroy?(record_index)
        @table.values.where(record_index: record_index).delete_all
        flash[:notice] = t('notice.table.delete_record', record_index: record_index)
      else
        flash[:alert] = t('notice.table.error_delete_record')
      end
    end  

    redirect_to @table
  end

  # GET /tables/new
  def new
    @table = Table.new
    @table.name = "OBJET_#{DateTime.now.to_i}"
    @table.lifo = true

    @modèles = User.find(1).tables.first(4)

    if current_user.compte_démo?
      flash[:notice] = t('notice.table.new_hint')
    end
  end

  # GET /tables/1/edit
  def edit
  end

  # POST /tables
  # POST /tables.json
  def create
    @table = Table.new(table_params)

    respond_to do |format|
      if @table.save
        @table.tables_users << TablesUser.create(table_id: @table.id, user_id: current_user.id, role: "Propriétaire")

        if params[:model_id].present?
          Table.find(params[:model_id]).fields.each do |f|
            field = f.dup
            field.row_order = @table.fields.maximum(:row_order).to_i + 1
            field.table = @table
            field.save
          end
        end
        format.html { redirect_to show_attrs_path(id: @table), notice: t('notice.table.new') }
        format.json { render :show, status: :created, location: @table }
      else
        format.html { render :new }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tables/1
  # PATCH/PUT /tables/1.json
  def update
    respond_to do |format|
      if @table.update(table_params)
        format.html { redirect_to table_path(id: @table), notice: t('notice.table.updated') }
        format.json { render :show, status: :ok, location: @table }
      else
        format.html { render :edit }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tables/1
  # DELETE /tables/1.json
  def destroy
    # supprime les champs
    @table.fields.delete_all

    @table.destroy

    respond_to do |format|
      format.html { redirect_to tables_url, notice: t('notice.table.destroyed')}
      format.json { head :no_content }
    end
  end

  def import
  end

  def import_do
    result = ImportCollection.new(params[:upload], current_user, params[:col_sep], params[:table_id]).call

    if result
      flash[:notice] = t('notice.table.imported', table: current_user.tables.last.name.humanize)
    else
      flash[:alert] = t('notice.table.import_failed', error: result.last)
    end
    redirect_to tables_path
  end

  def add_user_do
    session[:type_partage] = params[:type_partage]

    if not TablesUser.roles.keys.reject { |e| e == "Propriétaire" }.include?(params[:role])
      redirect_to add_user_path(@table), alert: t('notice.table.unavailable_role')
    elsif @user = User.find_by(email: (params[:type_partage] == "text") ? params[:email_text] : params[:email_list])
      unless @table.users.include?(@user)
        # ajoute le nouvel utilisateur aux utilisateurs de la table
        @table.tables_users << TablesUser.create(table_id: @table.id, user_id: @user.id, role: params[:role])
        UserMailer.notification_nouveau_partage(@user, @table).deliver_now
        flash[:notice] = t('notice.table.shared', table: @table.name, user: @user.name)
      else
        flash[:alert] = t('notice.table.already_shared', table: @table.name, user: @user.name)
      end
    else
      flash[:alert] = t('notice.table.user_not_found')
    end
    redirect_to partages_path(@table)
  end

  def partages
  end

  def partages_delete
    @user = User.find(params[:user_id])
    # supprime l'utilisateur que si ce n'est pas le dernier
    @table.users.delete(@user) if @table.users.count > 1
    flash[:notice] = t('notice.table.share_deactivated', user: @user.name)
    redirect_to request.referrer
  end 

  def logs

    # Afficher les changements pour la ligne #record_index
    if params[:record_index]
      sql = "audited_changes ->> 'record_index' = '#{params[:record_index].to_s}'"
      sql += " AND ("
    elsif not params[:user_id].blank?
      sql = "(user_id = '#{params[:user_id]}')"
      sql += " AND ("
    else
      sql = " ("
    end

    # et ayant comme champs ceux de la table en référence 
    @table.fields.each_with_index do |field, index|
       sql = sql + "(audited_changes ->> 'field_id' = '#{field.id.to_s}')"
       sql = sql + " OR " unless index == @table.fields.size - 1
    end
    sql = sql + ")"
    if sql == " ()"
      @audits = Audited::Audit.none
    else
      @audits = Audited::Audit.where(sql)
    end
    @audits = @audits.reorder('created_at DESC').page(params[:page])
  end

  def show_details
    unless params[:record_index].blank?
      @record_index = params[:record_index]
      @relation = Relation.where(relation_with_id: @table.id).first
      if @relation
        @records = @relation.field.values.where(data: @record_index).pluck(:record_index)
      end
      @sum = Hash.new(0)
    else
      redirect_to @table, alert: t('notice.table.no_value')
    end
  end
  
  def related_tables
    @relation = Relation.find(params[:relation])
    @record_index = params[:record_index]
    @records = @relation.field.values.where(data: @record_index).pluck(:record_index)
    @sum = Hash.new(0)
  end

  def icalendar
    user = User.find_by(slug: params[:user])

    date_records = @table.values.joins(:field).where('field.datatype': 'Date').pluck(:record_index)
    @values = @table.values.where(record_index: date_records)
    if @table.collecteur?(user)
      @values = @values.where(user_id: user.id)
    end

    if params[:filtre].present?
      records_index = @table.filters.find_by(slug: params[:filtre]).get_filtered_records
    else
      records_index = @values.pluck(:record_index).uniq
    end

    filename = "CrystalDATA_Agenda_iCal"
    response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.ics"'
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render plain: AgendaToIcalendar.new(@table, records_index).call
  end

  def securite
    @tables = current_user.tables.order(:name)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_table
      @table = Table.find_by(slug: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def table_params
      params.require(:table).permit(:name, :record_index, :lifo, :notification, :show_on_startup_screen, :public)
    end

    def is_user_authorized?
      authorize @table ? @table : Table
    end

    def info_notice
      if current_user.compte_démo? && flash[:notice] == nil && flash[:alert] == nil
        flash[:notice] = case params[:action]
        when 'index'
          t('notice.table.new_button')
        when 'show_attrs'
          t('notice.table.description')
        when 'partages'
          t('notice.table.share')
        when 'logs'
          t('notice.table.logs')
        when 'securite'
          t('notice.table.security')
        end
      end
    end
    
end
