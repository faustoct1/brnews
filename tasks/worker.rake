namespace :worker do  
  task :shared_user_signup do #=> :environment
    #%x( heroku config:set IRON_WORKER_PROJECT_ID=54ec256499936e00090000ff )
    #%x( heroku config:set IRON_WORKER_TOKEN=CC3hvL915xdBedKgUZJVdrBdMPA ) 
    #%x( iron_worker upload workers/user_signup )
  end
  
  task :shared_user_feed do #=> :environment
    #%x( heroku config:set IRON_WORKER_PROJECT_ID=54ec256499936e00090000ff )
    #%x( heroku config:set IRON_WORKER_TOKEN=CC3hvL915xdBedKgUZJVdrBdMPA ) 
    #%x( iron_worker upload workers/user_feed )
  end
    
  task :dedicated_user_signup do #=> :environment
    #%x( heroku config:set IRON_WORKER_PROJECT_ID=54e3fa27a096ac000600012b )
    #%x( heroku config:set IRON_WORKER_TOKEN=LBeOl26ERApaveroPadb-cRCPis )
    #%x( iron_worker upload workers/user_signup )
  end
  
  task :dedicated_user_feed do #=> :environment
    #%x( heroku config:set IRON_WORKER_PROJECT_ID=54e3fa27a096ac000600012b )
    #%x( heroku config:set IRON_WORKER_TOKEN=LBeOl26ERApaveroPadb-cRCPis )
    #%x( iron_worker upload workers/user_feed )
  end
end