module Labelized
  module LabelizedConcern
    extend ActiveSupport::Concern
        
    included do
      extend Support
      
      has_many :labelings, :as => :labeled, :dependent => :destroy
      has_many :labels, :through => :labelings
      
    end
    
    module InstanceMethods
      private
      
      def cache_label_set(label_set_name, labels)
        instance_variable_set label_cache_name(label_set_name), labels
      end
      
      def cache_label_get(label_set_name)
        instance_variable_get label_cache_name(label_set_name)
      end
      
      def label_cache_name(label_set_name)
        "@_labelized_#{label_set_name}".to_sym
      end
      
    end
    
    module ClassMethods
      def labelized(*params)
        setup_labelized params
        
        # thing.kind
        # thing.kind = ['this', 'that'] # throws Exeption
        # thing.kind = 'this' # OK!
        # thing.label 'this', :kind
        # labelized [:kind, :keywords, :tracks], :scope => [:community_id], :label_class => Label, :labeling_class => Labeling
        #
        class_eval do                    
          define_method('label') do |labels, label_set_name = :label|
            label_class = (labelized_options[:label_class_name] || 'Label').constantize
        
            labels = [labels].flatten
            return [] if labels.empty?
            
            self.labels = cache_label_set(label_set_name, label_class.label_scope(self).find_or_build_by_list(labels, self, label_set_name.to_s))
          end
          
          define_method('label_for') do |label_set_name|
            label_set_class = (labelized_options[:label_set_class_name] || 'LabelSet').constantize
            label_set = label_set_class.label_scope(self).find_or_initialize_by_name(label_set_name)
            cache_label_get(label_set_name) || self.labels.where(:label_set_id => label_set.id)
          end
          
          labelized_label_set_names.map(&:to_s).each do |label_set_name|
            define_method "#{label_set_name}=" do |labels|
              label labels, label_set_name
            end
        
            define_method "#{label_set_name}" do
              label_for label_set_name
            end
          end
        end
      end
    end
  end
end