require 'labelized/label_list'

module Labelized
  module LabelConcern
    extend ActiveSupport::Concern

    included do
      has_many :labelings, :inverse_of => :label, :dependent => :destroy
      belongs_to :label_set

      extend Support
    end

    module ClassMethods
      def labelized(params = {})
        setup_labelized params

        def find_or_build_by_list(labels, labeled, label_set_name = nil)
          label_set_class = (labelized_options[:label_set_class_name] || 'LabelSet').constantize

          unless label_set_name.blank?
            label_set_name.strip! # ooh lah lah
            scope = label_set_class.label_scope labeled
            label_set = scope.where(:name => label_set_name).first ||
              scope.new{ |label| label.name = label_set_name }
          end

          LabelList.from(labels).map do |label|
            scope = self.label_scope labeled
            name = label.strip
            label_set_id = label_set.id

            scope.where(:name => name, :label_set_id => label_set_id).first ||
              scope.new do |label|
                label.name = name
                label.label_set_id = label_set_id
              end
          end
        end
      end
    end

    def to_s
      name
    end
  end
end
