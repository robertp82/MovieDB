class RemoveMarinaFavoriteFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :marina_favorite, :boolean
  end
end
