module Labelized
  module LabelingConcern
    extend ActiveSupport::Concern

    included do
      belongs_to :label, :inverse_of => :labelings
      belongs_to :labeled, :polymorphic => true

      validates_presence_of :label, :labeled_id, :labeled_type
    end
  end
end
