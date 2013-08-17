class AddGenreFieldInMovies < ActiveRecord::Migration
  def up
   add_column :movies, :genre, :integer
  end

  def down
  end
end
