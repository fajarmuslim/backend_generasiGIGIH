class PdfExporter
    def export
        puts "Export to .pdf format"
    end
end

class XlsExporter
    def export
        puts "Export to .xls format"
    end
end

class Report
    def initialize(exporter)
        @exporter = exporter
    end

    def generate_monthly_report
        puts "Generating montly report"
        @exporter.export
    end
end

puts "Give me a PDF report!"
pdf_export = Report.new(PdfExporter.new)
pdf_export.generate_monthly_report

puts

puts "Give me a XLS report!"
xls_report = Report.new(XlsExporter.new)
xls_report.generate_monthly_report