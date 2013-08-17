class AddImdbKeysToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :imdb_id, :string
    add_column :movies, :poster_path, :string
  end
end
