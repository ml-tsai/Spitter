require 'faker'

namespace :db do
  desc "Fill database with fake names"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    
    admin = User.create!(
      :name => "Zarne",
      :email => "zarne@gcds.com.au",
      :password => "independent",
      :password_confirmation => "independent"
    )
    admin.toggle!(:admin)
    
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@gcds.com.au"
      password = "independent"
      User.create!(
        :name => name,
        :email => email,
        :password => password,
        :password_confirmation => password
      )
    end
    
  end
end