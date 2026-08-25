require "test_helper"

class ImportCollectionTest < ActiveSupport::TestCase
  setup do
    @user = users(:paul_hudson)
    @table = tables(:produits)
  end

  test "detects data types correctly" do
    service = ImportCollection.new(nil, @user, ";", nil, false)
    assert_equal "Texte", service.detect_string_type("Hello World")
    assert_equal "Nombre", service.detect_string_type("123")
    assert_equal "Oui_non?", service.detect_string_type("true")
    assert_equal "Oui_non?", service.detect_string_type("oui")
    assert_equal "Date", service.detect_string_type("2026-08-25")
  end

  test "imports new table from CSV" do
    csv_content = "Nom;Prix\nDoliprane;5"
    temp_file = Tempfile.new(["import_test", ".csv"])
    temp_file.write(csv_content)
    temp_file.rewind

    upload = ActionDispatch::Http::UploadedFile.new(
      tempfile: temp_file,
      filename: "import_test.csv",
      type: "text/csv"
    )

    service = ImportCollection.new(upload, @user, ";", nil, false)
    executed, exception = service.call

    assert executed, "Import should be executed successfully, error: #{exception&.message}"
    imported_table = Table.find_by(name: "import_test")
    assert_not_nil imported_table
    assert_equal 2, imported_table.fields.count
    ensure
      temp_file&.close
      temp_file&.unlink
  end
end
