host = 'localhost'
port = 27017

database_name = case Padrino.env
  when :development then 'linked_development'
  when :production  then 'linked_production'
  when :test        then 'linked_test'
end

# Use MONGO_URI if it's set as an environmental variable.
Mongoid::Config.sessions =
  if ENV['MONGOLAB_URI']
    {default: {uri: ENV['MONGOLAB_URI'] }}
  else
    {default: {uri: ''}}
  end
