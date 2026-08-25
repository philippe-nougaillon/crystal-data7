require "test_helper"

class CollectionToXlsTest < ActiveSupport::TestCase
  setup do
    @table = tables(:produits)
  end

  test "exports table records to Spreadsheet Workbook" do
    records = [1]
    service = CollectionToXls.new(@table, records)
    workbook = service.call

    assert_kind_of Spreadsheet::Workbook, workbook
    sheet = workbook.worksheet(0)
    assert_not_nil sheet
  end
end
