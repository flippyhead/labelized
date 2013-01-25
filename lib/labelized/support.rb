require 'active_support/core_ext/string/inflections'

module Labelized
  module Support
    def self.singular?(str)
      str.to_s.pluralize != str.to_s && str.to_s.singularize == str.to_s
    end
  
    def self.extract_params(*params)
      labels = params.to_a.flatten.compact
      options = labels[-1].kind_of?(Hash) ? labels.slice!(-1) : {}
      labels = labels.map(&:to_sym)
      [labels, options]
    end
    
    def setup_labelized(params)
      label_sets, options = Support.extract_params(params)
      scopes = [options[:scope]].flatten
      
      self.setup_labelized_options(options) 
      self.setup_labelized_label_set_names(label_sets) 
      self.setup_label_scope(scopes)
    end
    
    # Sets up scoping for labels and label sets
    # Typically the labeled item is passed to the scope
    # So label_set with a :community_id scope, will look for labels with a community_id
    # that have the same value as the community_id on the thing being labled
    def setup_label_scope(scopes)
      return if scopes.blank?
      self.class_eval do
        scope :label_scope, lambda {|labeled| where(*scopes.collect{|s| {s => labeled.send(s)}}.flatten)}
      end
    end
    
    def setup_labelized_options(options)
      self.class_attribute :labelized_options
      self.labelized_options = options
    end
    
    def setup_labelized_label_set_names(names)
      self.class_attribute :labelized_label_set_names
      self.labelized_label_set_names = names
    end
    
    def is_labelized?
      true
    end
  end
end
