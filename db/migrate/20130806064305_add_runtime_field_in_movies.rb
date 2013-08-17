class AddRuntimeFieldInMovies < ActiveRecord::Migration
  def up
   add_column :movies, :runtime, :integer
  end

  def down
  end
end
