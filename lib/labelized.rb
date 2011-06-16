require 'active_support'
require 'active_record'

require 'labelized/support'
require 'labelized/label_concern'
require 'labelized/labeling_concern'
require 'labelized/label_set_concern'
require 'labelized/labelized_concern'


# if defined?(ActiveRecord::Base)
#   ActiveRecord::Base.extend ActsAsTaggableOn::Taggable
#   ActiveRecord::Base.send :include, ActsAsTaggableOn::Tagger
# end
# 
# if defined?(ActionView::Base)
#   ActionView::Base.send :include, ActsAsTaggableOn::TagsHelper
# end