class ExportPdf
  include Prawn::View
  include ActionView::Helpers::NumberHelper
  
  # Taille et orientation du document par défaut
  def document
    @document ||= Prawn::Document.new(page_size: 'A4', page_layout: :landscape)
  end

  def initialize
    super()

    self.font_families.update("OpenSans" => {
      :normal => Rails.root.join("vendor/assets/fonts/Open_Sans/static/OpenSans/OpenSans-Regular.ttf"),
      :italic => Rails.root.join("vendor/assets/fonts/Open_Sans/static/OpenSans/OpenSans-Italic.ttf"),
      :bold => Rails.root.join("vendor/assets/fonts/Open_Sans/static/OpenSans/OpenSans-Bold.ttf"),
      :bold_italic => Rails.root.join("vendor/assets/fonts/Open_Sans/static/OpenSans/OpenSans-BoldItalic.ttf")
    })

    @margin_down = 15
    @image_path =  "#{Rails.root}/app/assets/images/"
  end

  def export_collection(table, records)
    font "Courier"
    font_size 8

    data_table = [table.fields.ordered.pluck(:name)]

    index = 1
    records.each do | record_index |
      values = table.values.joins(:field).records_at(record_index).order("fields.row_order").pluck(:data)
      fields_to_export = []
      # TODO : à mettre dans une fonction (équivalent à icalendar / collection_to_csv/to_xls)
      table.fields.each_with_index do | field,index |
        if field.Collection?
          fields_to_export << field.get_linked_table_record(values[index])
        elsif field.Signature?
          value = values[index].blank? ? 'Pas signé' : 'Signé'
          fields_to_export << value
        elsif field.QRCode?
          value = values[index].blank? ? 'Indisponible' : 'Disponible'
          fields_to_export << value
        else
          fields_to_export << values[index]
        end
      end
      data_table << fields_to_export

      index += 1
    end

    text table.name.pluralize.humanize, size: 18, style: :bold, align: :center
    move_down 30

    table(data_table, header: true) do
      row(0).font_style = :bold
    end
  end
  
end