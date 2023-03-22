require 'csv'

class DummyReport < Reporter::Report
  class XMLBuidler
    def call(report)
      io = StringIO.new
      io.write "<xml></xml>"
      io
    end
  end

  set_form_class Reporter::TimeRangeForm

  builder :xml, builder_class: XMLBuidler

  builder :xlsx do |report|
    p = Axlsx::Package.new
    wb = p.workbook

    wb.add_worksheet(name: 'Basic Worksheet') do |sheet|
      sheet.add_row ['First', 'Second', 'Third']
      sheet.add_row [1, 2, 3]
    end

    p.to_stream
  end

  builder :json do |report|
    io = StringIO.new
    io.write({ json: true }.to_json)
    io
  end
end
