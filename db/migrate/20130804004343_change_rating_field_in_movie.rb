class ChangeRatingFieldInMovie < ActiveRecord::Migration
  def up
   change_column :movies, :rating, :decimal, :precision =>  4, :scale => 2
  end

  def down
  end
end
