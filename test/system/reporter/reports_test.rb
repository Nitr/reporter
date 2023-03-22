require "application_system_test_case"

module Reporter
  class ReportsTest < ApplicationSystemTestCase
    setup do
      @report = reporter_reports(:one)
    end

    test "visiting the index" do
      visit reports_url
      assert_selector "h1", text: "Reports"
    end

    test "should create report" do
      visit reports_url
      click_on "New report"

      click_on "Create Report"

      assert_text "Report was successfully created"
      click_on "Back"
    end

    test "should update Report" do
      visit report_url(@report)
      click_on "Edit this report", match: :first

      click_on "Update Report"

      assert_text "Report was successfully updated"
      click_on "Back"
    end

    test "should destroy Report" do
      visit report_url(@report)
      click_on "Destroy this report", match: :first

      assert_text "Report was successfully destroyed"
    end
  end
end