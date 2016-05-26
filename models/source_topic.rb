class SourceTopic < ActiveRecord::Base
  belongs_to :topic
  belongs_to :source
end
