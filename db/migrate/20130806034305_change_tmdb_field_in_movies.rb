class ChangeTmdbFieldInMovies < ActiveRecord::Migration
  def up
   add_index :movies, :tmdb_id, :unique => true
  end

  def down
  end
end
