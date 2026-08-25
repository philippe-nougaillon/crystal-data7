require "test_helper"

class CollectionToCsvTest < ActiveSupport::TestCase
  setup do
    @table = tables(:produits)
  end

  test "exports table records to CSV string" do
    records = [1]
    service = CollectionToCsv.new(@table, records)
    csv_string = service.call

    assert_kind_of String, csv_string
    assert_includes csv_string, "Nom"
  end
end
