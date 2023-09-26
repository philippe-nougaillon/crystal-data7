class TablesController < ApplicationController
  before_action :set_table, except: [:new, :create, :import, :import_do, :index]
  before_action :is_user_authorized?

  # GET /tables
  # GET /tables.json
  def index
    @tables = current_user.tables.includes(:fields)
    respond_to do |format|
      format.html.phone
      format.html.none 
    end
  end

  # GET /tables/1
  # GET /tables/1.json
  def show
    @sum = Hash.new(0)
    @filters = {}
    @filter_results = {}

    # recherche les lignes 
    unless params.permit(:search).blank?
      search = "%#{ params[:search].strip }%"
      @values = @table.values.where("data ILIKE ?", search)
      # Est-ce qu'il y a des Tables liées ?
      @table.fields.Collection.each do | field_table |
        # Rchercher dans les values de ce champ lié si valeurs recherchées
        s = /#{ params[:search].strip }/i
        results = field_table.populate_linked_table.select{|k,v| v.match(s)}
        # Ajouter les clés trouvées
        @values = @values + field_table.values.where(data: results.keys)
      end
    else
      @values = @table.values
    end
    @filters[:search] = search
    @filter_results[:search] = @values.pluck(:record_index).uniq

    # Applique les filtres de type SELECT_TAG
    unless params[:select].blank?
      params[:select].each do | option | 
        unless option.last.blank? 
          field = Field.find(option.first)
          filter_records = @table.values.where(field: field, data: option.last).pluck(:record_index) 
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
          filter_records = @table.values.where(field: field).where("DATE(data) BETWEEN ? AND ?", start_date, end_date).pluck(:record_index) 
          @filters[field_id] = [start_date, end_date]
          @filter_results[field_id] = filter_records
        end
      end
    end

    @records = @filter_results.values.reduce(:&)

    if @table.lifo 
     # calcule la date maximum de chaque ligne d'enregistrement 
     h = @table.values.select("values.record_index").group("fields.row_order, values.record_index").maximum(:updated_at)
     # inverse le hash (keys <=> values) pour faire un tri par date et retourne les record_index
     @records = Hash[h.sort_by{|k, v| v}.reverse].keys & @records
    end     

    if params[:sort_by]
      # ordre de tri ASC/DESC
      order_by = (params[:sort_by] == session[:sort_by]) ? ((session[:order_by] == "DESC") ? "ASC" : "DESC") : "ASC"
      
      @records = @table.values.records_at(@records)
                              .where(field_id: params[:sort_by])
                              .order("data #{order_by}")
                              .pluck(:record_index)
      
      session[:sort_by] = params[:sort_by]
      session[:order_by] = order_by
    end

    respond_to do |format|
      format.html
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{@table.name}-#{l(DateTime.now, format: :compact)}\"" }
    end 
  end

  def show_attrs 
    @field = Field.new(table_id: @table.id)
    @fields = Field.datatypes.keys.to_a
  end

  # formulaire d'ajout / modification
  def fill
    if params[:record_index]
      # modification ligne existante
      @record_index = params[:record_index]
    else
      # ajout d'une ligne
      @record_index = @table.increment_record_index
    end
  end

  # formulaire d'ajout / modification posté
  def fill_do
    table = Table.find(params[:table_id])
    user = current_user
    data = params[:data]
    record_index = data.keys.first
    values = data[record_index.to_s]

    if not values.values.compact_blank.blank?

      inserts_log = []
      notif_items = []

      # update? = si données existent déjà, on les supprime avant pour pouvoir ajouter les données modifiées 
      update = table.values.where(record_index:record_index).any?
      # garde la date de dernière mise à jour
      created_at_date = table.values.where(record_index:record_index).first.created_at if update

      # quel champ a été modifié ?
      table.fields.each do |field|
        value = values[field.id.to_s]
        if field.obligatoire and value.blank?
          flash[:alert] = "Champ(s) obligatoire(s) manquant(s)"
          redirect_to action: 'fill', record_index: record_index
          return
        end  

        # enregistre le fichier
        if field.datatype == 'Fichier' || field.datatype == 'Image' || field.datatype == 'PDF'
          if value
            b = Blob.new()
            b.file.attach(value)
            b.save
            value = b.id
            created_at_date = DateTime.now
          else 
            # si l'utilisateur n'a pas choisi de fichier
            # on passe pour ne pas écraser le fichier existant
            next
          end
        end

        if field.datatype == 'Formule'
          value = field.evaluate(table, record_index) # evalue le champ calculé
        end          
    
        # test si c'est un update ou new record
        old_value = table.values.find_by(record_index:record_index, field:field)

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
                            created_at: created_at_date)
            end
          end
        else
          # enregistrer les nouvelles données
          Value.create(field_id: field.id, 
                      record_index: record_index, 
                      data: value, 
                      created_at: created_at_date)

        end
      end

      # notifier l'utilisateur d'un ajout 
      if not update and table.notification
        UserMailer.notification(table, notif_items).deliver_later
      end

      redirect_to table, notice: "Données #{update ? 'modifiées' : 'ajoutées'} avec succès :)"
    else
      redirect_to table, alert: "Aucune donnée enregistrée"
    end
  end  

  def delete_record
    if params[:record_index]
      record_index = params[:record_index].to_i
      if @table.record_can_be_destroy?(record_index)
        @table.values.where(record_index: record_index).delete_all
        flash[:notice] = "Enregistrement ##{record_index} supprimé avec succès"
      else
        flash[:alert] = "Cet enregistrement n'a pas été supprimé car il est utilisé dans d'autres Tables !"
      end
    end  

    redirect_to @table
  end

  # GET /tables/new
  def new
    @table = Table.new
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
        format.html { redirect_to show_attrs_path(id: @table), notice: "Objet créé. Vous pouvez maintenant y ajouter des attributs" }
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
        format.html { redirect_to show_attrs_path(id: @table), notice: 'Table modifiée.' }
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
    @table.fields.destroy_all

    # ????
    # # supprime les fichiers liés
    # @table.values.each do | value |
    #     value.field.delete_file(value.data) if value.field and value.field.Fichier? and value.data
    #     value.destroy
    #   end
    @table.destroy

    respond_to do |format|
      format.html { redirect_to tables_url, notice: 'Table supprimée.'}
      format.json { head :no_content }
    end
  end

  def import
  end

  def import_do
    require 'rake'

    #Save file to local dir
    filename = params[:upload].original_filename
    filename_with_path = Rails.root.join('public', 'tmp', filename)
    File.open(filename_with_path, 'wb') do |file|
        file.write(params[:upload].read)
    end

    Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
    CrystalData::Application.load_tasks 
    Rake::Task['tables:import'].invoke(filename_with_path, filename, current_user.id, request.remote_ip)

    @new_table = Table.last
    redirect_to tables_path, notice: "Importation terminé. Table '#{Table.last.name.humanize}' créée avec succès."
  end

  def export
  end

  def export_do
    require 'csv'

    unless params[:debut].blank? and params[:fin].blank?
      @debut = params[:debut]
      @fin = params[:fin]
    else
      @debut = '01/01/1900'
      @fin = '01/01/2100'
    end

    #updated_at_list = @table.values.group(:record_index).maximum(:updated_at)

    @records = @table.values.pluck(:record_index).uniq

    @csv_string = CSV.generate(col_sep:',') do |csv|
      csv << @table.fields.pluck(:name)

      @records.each do | index |
        values = @table.values.joins(:field).records_at(index).order("fields.row_order").pluck(:data)
        #updated_at = updated_at_list[index]
        cols = []
        @table.fields.each_with_index do | field,index |
          if field.datatype == "Signature" and values[index]
            cols << "Signé"
          else
            cols << (values[index] ? values[index].to_s.gsub("'", " ") : nil) 
          end
        end
        #cols << l(updated_at) 
        csv << cols
      end    
    end

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"#{@table.name.humanize + '.csv'}\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def add_user
  end

  def add_user_do
    if not TablesUser.roles.keys.reject { |e| e == "Propriétaire" }.include?(params[:role])
      redirect_to add_user_path(@table), alert: "Rôle indisponible"
    elsif @user = User.find_by(email:params[:email])
      unless @table.users.include?(@user)
        # ajoute le nouvel utilisateur aux utilisateurs de la table
        @table.tables_users << TablesUser.create(table_id: @table.id, user_id: @user.id, role: params[:role])
        # UserMailer.notification_nouveau_partage(@user, @table).deliver_later
        flash[:notice] = "Partage de la table '#{@table.name.humanize}' avec l'utilisateur '#{@user.name}' activé"
      else
        flash[:alert] = "Partage de la table '#{@table.name.humanize}' avec l'utilisateur '#{@user.name}' déjà existant !"
      end
    else
      flash[:alert] = "Utilisateur inconnu ! Créez un compte en allant sur 'Créer un compte' dans le menu utilisateur"
      redirect_to add_user_path(@table)
      return
    end
    redirect_to partages_path(@table)
  end

  def partages
  end

  def partages_delete
    @user = User.find(params[:user_id])
    # supprime l'utilisateur que si ce n'est pas le dernier
    @table.users.delete(@user) if @table.users.count > 1
    flash[:notice] = "Le partage avec l'utilisateur '#{@user.name}' a été désactivé !"
    redirect_to partages_path
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
    @audits = Audited::Audit.where(sql)
    @audits = @audits.reorder('created_at DESC').paginate(page: params[:page])
  end

  # ????
  # def activity
  #   unless params[:type_action].blank?
  #     @logs = @table.logs.where(action:params[:type_action].to_i)
  #   else
  #     @logs = @table.logs.all
  #   end

  #   unless params[:user_id].blank?
  #     @logs = @logs.where(user_id:params[:user_id])
  #   end

  #   # applique les filtres
  #   @records_filter = []
  #   if params[:select]
  #     params[:select].each do | option | 
  #       unless option.last.blank? 
  #         field = Field.find(option.first)
  #         filter_records = @table.values.where(field:field, data:option.last).pluck(:record_index) 
  #         if @records_filter.empty?
  #           @records_filter = filter_records 
  #         else
  #           @records_filter = @records_filter & filter_records 
  #         end  
  #       end
  #     end
  #     @logs = @logs.where(record_index:@records_filter) if @records_filter.any?
  #   end

  #   @hash = @logs.group_by_day("logs.created_at").count
  #   fields_count = @table.fields.count

  #   # arroudir au multiple du nombre de champs supérieur
  #   @hash.each do |key,value| 
  #     if value % fields_count == 0 
  #       r = value / fields_count
  #     else
  #       r = value + fields_count - (value % fields_count) 
  #     end 
  #     #logger.debug "[DEBUG] value:#{value} fields:#{fields_count} r:#{r}"
  #     @hash[key] = r / fields_count
  #   end  
  # end

  def show_details
    unless params[:record_index].blank?
      @record_index = params[:record_index]
      @relation = Relation.where(relation_with_id: @table.id).first
      if @relation
        @records = @relation.field.values.where(data: @record_index).pluck(:record_index)
      end
      @sum = Hash.new(0)
    else
      redirect_to @table, alert: "donnée non existante"
    end
  end
  
  def related_tables
    @relation = Relation.find(params[:relation])
    @record_index = params[:record_index]
    @records = @relation.field.values.where(data: @record_index).pluck(:record_index)
    @sum = Hash.new(0)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_table
      @table = Table.find_by(slug: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def table_params
      params.require(:table).permit(:name, :record_index, :lifo, :notification, :show_on_startup_screen)
    end

    def is_user_authorized?
      authorize @table ? @table : Table
    end
end
