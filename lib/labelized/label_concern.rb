module Labelized
  module LabelConcern
    extend ActiveSupport::Concern
    
    included do
      has_many :labelings, :dependent => :destroy
      belongs_to :label_set
      
      extend Support
    end
      
    module ClassMethods
      def labelized(params)
        setup_labelized params
        
        def find_or_build_by_list(labels, labeled, label_set_name = nil)
          label_set_class = (labelized_options[:label_set_class_name] || 'LabelSet').constantize
          existing_labels = self.label_scope(labeled).where(:name => labels)

          unless label_set_name.blank?
            label_set_name.strip! # ooh lah lah
            label_set = label_set_class.label_scope(labeled).find_or_initialize_by_name(label_set_name)
          end

          new_label_names = labels.reject do |name| 
            existing_labels.any? do |label|
              name.downcase == label.name.downcase
            end
          end

          new_labels = new_label_names.map do |name| 
            name.strip!
            self.label_scope(labeled).build(:name => name, :label_set => label_set)
          end

          existing_labels + new_labels
        end          
        
      end
    end    
  end
end