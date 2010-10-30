Factory.define :user do |u|
  u.login                 "johndoe"
  u.email                 "john.doe@originatelabs.com"
  u.password              "mypassword"
  u.password_confirmation "mypassword"
end
