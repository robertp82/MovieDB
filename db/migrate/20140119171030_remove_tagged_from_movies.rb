class RemoveTaggedFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :tagged, :boolean
  end
end
