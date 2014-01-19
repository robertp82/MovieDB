class RemoveWantedFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :wanted, :boolean
  end
end
