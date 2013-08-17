class AddRobFavoriteFieldInMovies < ActiveRecord::Migration
  def up
   add_column :movies, :rob_favorite, :boolean, :default => false
   add_column :movies, :marina_favorite, :boolean, :default => false
  end

  def down
  end
end
