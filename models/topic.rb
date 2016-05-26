class Topic < ActiveRecord::Base
  has_many :users, through: :user_topics
  has_many :user_topics

  has_many :sources, through: :source_topics
  has_many :source_topics
end
