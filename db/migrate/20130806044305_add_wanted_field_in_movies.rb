class AddWantedFieldInMovies < ActiveRecord::Migration
  def up
   add_column :movies, :wanted, :boolean
  end

  def down
  end
end
