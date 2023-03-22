module Reporter
  class BaseForm
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    attribute :report_formats, array: true, default: []
    validates :report_formats, presence: true

    def to_partial_path
      element = ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(self.class.name))
      "forms/#{element}"
    end

  end
end
