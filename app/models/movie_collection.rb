class MovieCollection < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :movies
  attr_accessible :movies
end
