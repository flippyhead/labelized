module Labelized
  module LabelSetConcern
    extend ActiveSupport::Concern
        
    included do
      has_many :labelings, :dependent => :destroy
      has_many :labels #, :through => :labelings
      validates_presence_of :name
      
      extend Support
    end

    module ClassMethods
      def labelized(params)
        setup_labelized params
      end
    end
  end
end