Factory.define :user do |user|
  user.name                    "Zarne"
  user.email                   "zarne@gcds.com.au"
  user.password                "independent"
  user.password_confirmation   "independent"
end

Factory.sequence :email do |n|
  "person-#{n}@gcds.com.au"
end