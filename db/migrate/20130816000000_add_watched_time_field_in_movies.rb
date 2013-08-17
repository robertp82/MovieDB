class AddWatchedTimeFieldInMovies < ActiveRecord::Migration
  def up
   add_column :movies, :watched_at, :datetime
  end

  def down
  end
end
