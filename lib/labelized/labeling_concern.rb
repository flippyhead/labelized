module Labelized
  module LabelingConcern
    extend ActiveSupport::Concern
    
    included do
      belongs_to :label
      belongs_to :labeled, :polymorphic => true    
      validates_presence_of :label_id, :labeled_id, :labeled_type
    end
  end
end