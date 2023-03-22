module Reporter
  class ReportJob < ApplicationJob
    queue_as :default

    def perform(report)
      report.build!
    end
  end
end
