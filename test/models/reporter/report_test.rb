require "test_helper"

module Reporter
  class ReportTest < ActiveSupport::TestCase

    def setup
      @form = {
        start: DateTime.current - 1.day,
        end: DateTime.current,
        report_type: 'DummyReport',
        report_format: 'xml'
      }

      @report = Report.new type: 'DummyReport', form: @form
    end

    test 'default status is pending' do
      assert Report.new.pending?
    end

    test 'default_form_class must be BaseForm by default' do
      assert Report.default_form_class == Reporter::BaseForm
    end

    test 'override default form class' do
      new_form_class = Class.new
      DummyReport.default_form_class = new_form_class

      sub_class = Class.new(DummyReport)

      assert Report.default_form_class == Reporter::BaseForm, 'default_form_class has been changed for base class'
      assert DummyReport.default_form_class == new_form_class, 'default_form_class has not been changed'
      assert sub_class.default_form_class == new_form_class, 'default_form_class for subclass of DummyReport has not been inharited'
    end

    test "invalid without form" do
      @report.form = nil

      refute @report.valid?, 'report valid without form'
      assert_not_nil @report.errors[:form], 'no validation error for form present'
    end

    test "invalid without format" do
      @report.form_object.report_format = nil

      refute @report.valid?, 'report valid without format'
      assert @report.errors.details[:format].any? { |err| err[:error] == :blank }, 'no validation error for format present'
    end

    test "invalid inclusion format" do
      @report.form_object.report_format = 'test'

      refute @report.valid?, 'report valid inclusion format'
      assert @report.errors.details[:format].any? { |err| err[:error] == :inclusion }, 'no validation error for format inclusion'
    end

    test "invalid form object" do
      @report.form_object.report_format = nil

      refute @report.valid?, 'report valid inclusion format'
      assert @report.errors.details[:form_object].any? { |err| err[:error] == :invalid }, 'no validation error for form_object'
    end

    test "rebuild form object when update form" do
      prev_form_object = @report.form_object

      @report.form = @form.dup

      assert prev_form_object != @report.form_object, 'form_object has not been rebuilded'
    end

    test "file_name format is class_name + format" do
      assert @report.file_name.eql?('DummyReport.xml')
    end

    test "build xml report via builder_class" do
      assert_changes -> { @report.status }, from: 'pending', to: 'success' do
        @report.build!
      end

      assert @report.is_a?(::DummyReport)
      assert @report.valid?
      assert @report.file.attached?
      assert @report.success?
    end

    test "build json report via block" do
      @report.form = @form.merge(report_format: 'json')

      assert_changes -> { @report.status }, from: 'pending', to: 'success' do
        @report.build!
      end

      assert @report.is_a?(DummyReport)
      assert @report.valid?
      assert @report.file.attached?
      assert @report.success?
    end

    test "skip build if processing" do
      @report.update status: Reporter::Report::PROCESSING

      assert_no_changes -> { @report.status } do
        @report.build!
      end
    end

    test "change status to failed and raise error" do
      @report.form_object.report_format = nil

      assert_raises do
        @report.build!
      end

      assert @report.failed?
    end

  end
end
