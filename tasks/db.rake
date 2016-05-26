namespace :db do
  task :create_indexes => :environment do
  #
    begin
      Rails.application.eager_load!
    rescue Object => e
    end

  #
    begin
      Bundler.require(:default, :assets, 'production')
    rescue Object => e
    end

  #
    to_index_models = [] 

    ObjectSpace.each_object(Module) do |object|
      begin
        to_index_models.push(object) if object.respond_to?(:create_indexes)
      rescue Object => e
        warn "failed on: #{ object }.respond_to?(:create_indexes)"
      end
    end

  #
    to_index_models.sort! do |a, b|
      begin
        a.name <=> b.name
      rescue Object
        0
      end
    end

  #
    begin
      to_index_models.uniq!
    rescue Object
    end

  #
    to_index_models.each do |model|
      begin
        model.create_indexes
        puts "indexed: #{ model }"
      rescue Object => e
        warn "failed on: #{ model }#create_indexes"
      end
    end
  end
end