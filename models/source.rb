class Source < ActiveRecord::Base
  has_many :topics, through: :source_topics
  has_many :source_topics
end
