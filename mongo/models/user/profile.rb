class Profile
  include Mongoid::Document

  field :data, type: Hash
  field :user_id, type: String

  index(user_id: 1)
  
end