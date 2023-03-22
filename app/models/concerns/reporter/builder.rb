module Reporter
  module Builder
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :builders

      def builder(format, builder_class: nil, &block)
        @builders ||= {}
        @builders[format.to_s] = block_given? ? block : builder_class.new
      end
    end

    def builders
      self.class.builders
    end

    def available_formats
      builders.keys
    end

    private

    def lookup_builder(format)
      self.class.builders.fetch(format.to_s)
    end
  end
end
