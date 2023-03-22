module Reporter
  class ReportsController < ApplicationController
    include Pagy::Backend

    before_action :set_report, only: %i[ show edit update destroy ]

    # GET /reports
    def index
      @pagy, @reports = pagy(Report.order(id: :desc))
    end

    # GET /reports/new
    def new
      @report = Report.new(type: params[:type])
    end

    # POST /reports
    def create
      @report = Report.new(report_params)

      if @report.save
        ReportJob.perform_later(@report)

        redirect_to reports_path, notice: "Report was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_report
        @report = Report.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def report_params

        params.fetch(:report, {}).permit(:type, form: {})
      end
  end
end
