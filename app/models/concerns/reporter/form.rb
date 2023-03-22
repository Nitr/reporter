module Reporter
  module Form
    extend ActiveSupport::Concern

    included do
      class_attribute :default_form_class, default: Reporter::BaseForm
    end

    class_methods do
      def form_class
        @form_class || default_form_class
      end

      private

      def set_form_class(form_class)
        @form_class = form_class
      end
    end

    def form_object
      build_form_object! unless @form_object
      @form_object
    end

    def build_form_object!
      @form_object = self.class.form_class.new(form) if form
    end

  end
end
