class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.integer :tmdb_id
      t.decimal :rating
      t.integer :year
      t.text :description

      t.timestamps
    end
  end
end
