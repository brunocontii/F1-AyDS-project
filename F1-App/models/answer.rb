class Answer < ActiveRecord::Base
    belongs_to :user
    has_and_belongs_to_many :gamemode
    belongs_to :question
    belongs_to :option
end