User.create!( name:   "Bruce Wayne",
              email:  "example@railstutorial.org",
              password:             "foobar",
              password_confirmation: "foobar",
              admin: true)

99.times do |n|
  name = Faker::Name.name
  email = "example#{n+1}@foobar.com"
  password = "password"
  User.create!( name:   name,
                email:  email,
                password:              password,
                password_confirmation: password)
end