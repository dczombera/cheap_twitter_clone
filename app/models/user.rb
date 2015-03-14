class User < ActiveRecord::Base
	validates :name,	presence: true
	validates :email, 	presence: true
	#TODO chapter 6.2.3 length validation
end
