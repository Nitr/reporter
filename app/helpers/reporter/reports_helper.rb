module Reporter
  module ReportsHelper
    include ::Pagy::Frontend

    def report_status(report)
      content_tag :span,
        report.status,
        class: class_names('badge', {
          'text-bg-secondary': report.pending?,
          'text-bg-info': report.processing?,
          'text-bg-success': report.success?,
          'text-bg-danger': report.failed?
        })
    end

    def form_data(report)
      content_tag :a, "...",
        tabindex: 0,
        role: 'button',
        data: {
          'bs-trigger': 'hover',
          'bs-placement': 'left',
          'bs-toggle': 'popover',
          'bs-title': 'Form Data',
          'bs-title-html': true,
          'bs-content': report.form_object.as_json.to_s,
        }
    end

    def report_form(report)
      form_with(model: report, scope: :report, url: reports_path, class: 'row g-3') do |form|
        concat form.hidden_field :type
        yield form
      end
    end
  end
end
