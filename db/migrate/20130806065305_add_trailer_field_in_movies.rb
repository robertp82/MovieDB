class AddTrailerFieldInMovies < ActiveRecord::Migration
  def up
   add_column :movies, :trailer, :string
  end

  def down
  end
end
