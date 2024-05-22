class User < ActiveRecord::Base
    has_one :profile
    has_and_belongs_to_many :gamemode
    has_many :answer
    has_many :wildcard
end