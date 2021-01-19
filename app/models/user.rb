class User < ActiveRecord::Base
    validates :name, :email, :password, presence: true
    validates :email, uniqueness: true
    has_secure_password
    has_many :vacations
end