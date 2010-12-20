Factory.define :user do |u|
  u.login                 "johndoe"
  u.email                 "john.doe@originatelabs.com"
  u.password              "mypassword"
  u.password_confirmation "mypassword"
end

Factory.define :entry do |e|
  e.content    "entry content"
  e.due_date   Date.today
  e.order_time Time.now
end

Factory.define :recurring_entry do |r|
  r.content "splogsplig"
  r.period  "daily"
end
