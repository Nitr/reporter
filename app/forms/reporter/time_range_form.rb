module Reporter
  class TimeRangeForm < Reporter::BaseForm
    attribute :start, :datetime
    attribute :end, :datetime

    validates :start, :end, presence: true
    validates :end, comparison: { greater_than: :start }
  end
end
