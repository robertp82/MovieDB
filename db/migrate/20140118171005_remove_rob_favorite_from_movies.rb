class RemoveRobFavoriteFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :rob_favorite, :boolean
  end
end
