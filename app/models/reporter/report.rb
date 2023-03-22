module Reporter
  class Report < ApplicationRecord
    include ActiveStorage::Blob::Analyzable
    include Reporter::Builder
    include Reporter::Form

    STATUSES = [
      PENDING     = :pending,
      PROCESSING  = :processing,
      SUCCESS     = :success,
      FAILED      = :failed
    ].freeze

    enum :status, STATUSES.to_h { |s| [s, s.to_s] }, default: PENDING

    has_many_attached :files

    validates :form, presence: true
    validate :validate_form
    validate :validate_formats

    def available_formats
      self.class.builders.keys
    end

    def form=(value)
      super
      build_form_object!
      value
    end

    def build!
      with_lock do
        return if processing?
        processing!
      end

      transaction do
        blobs = form_object.report_formats.map do |format|
          io = lookup_builder(format).call(self).tap(&:rewind)

          { io: io, filename: file_name(format) }
        end

        files.attach(blobs)

        update!(status: SUCCESS, processed_at: Time.current)
      end
    rescue StandardError => e
      failed!
      raise e
    end

    def file_name(format)
      [self.class.model_name.name, format].join('.')
    end

    private

    def validate_form
      errors.add(:form_object, :invalid, message: form_object.errors.full_messages.join('. ')) if form_object.present? && form_object.invalid?
    end

    def validate_formats
      form_object.report_formats.each do |format|
        errors.add(:form, :invalid, message: "Invalid format #{format}") unless format.in?(available_formats)
      end
    end
  end
end
