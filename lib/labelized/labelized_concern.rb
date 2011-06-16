module Labelized
  module LabelizedConcern
    extend ActiveSupport::Concern
        
    included do
      extend Support
    end
    
    module ClassMethods
      def labelized(*params)
        setup_labelized params
        
        # thing.kind
        # thing.kind = ['this', 'that'] # throws Exeption
        # thing.kind = 'this' # OK!
        # labelized [:kind, :keywords, :tracks], :scope => [:community_id], :label_class => Label, :labeling_class => Labeling
        #
        class_eval do
          has_many :labelings, :as => :labeled, :dependent => :destroy
          has_many :labels, :through => :labelings
      
          labelized_label_set_names.map(&:to_s).each do |label_set_name|
        
            define_method "#{label_set_name}=" do |labels|
              label_class = (labelized_options[:label_class_name] || 'Label').constantize
          
              labels = [labels].flatten
              return [] if labels.empty?
              
              self.labels = label_class.find_or_build_by_list(labels, self, label_set_name)
            end
        
            define_method "#{label_set_name}" do
              label_set_class = (labelized_options[:label_set_class_name] || 'LabelSet').constantize
              label_set = label_set_class.label_scope(self).find_or_initialize_by_name(label_set_name)
              self.labels.where(:label_set_id => label_set.id)
            end
          end
        end
      end
    end
  end
end