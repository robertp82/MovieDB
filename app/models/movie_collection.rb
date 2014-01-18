class MovieCollection < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :movies
  attr_accessible :movies, :collection_type
  has_one :collection_type
end
