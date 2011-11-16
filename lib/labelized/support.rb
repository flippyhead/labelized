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
    
    def setup_label_scope(scopes)
      return if scopes.blank?
      self.class_eval do
        scope :label_scope, lambda {|labeled| where(*scopes.collect{|s| {s => labeled.send(s)}}.flatten)}
      end
    end
    
    def setup_labelized_options(options)
      write_inheritable_attribute(:labelized_options, options)
      class_inheritable_reader(:labelized_options)
    end
    
    def setup_labelized_label_set_names(names)
      write_inheritable_attribute(:labelized_label_set_names, names)
      class_inheritable_reader(:labelized_label_set_names)
    end
    
    def is_labelized?
      true
    end
  end
end