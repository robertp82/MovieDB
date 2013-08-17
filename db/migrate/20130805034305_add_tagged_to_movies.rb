class AddTaggedToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :tagged, :boolean
  end
end
