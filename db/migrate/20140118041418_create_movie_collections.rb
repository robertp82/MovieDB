class CreateMovieCollections < ActiveRecord::Migration
  def change
    create_table :movie_collections do |t|
      t.string :name
      t.belongs_to:user

      t.timestamps
    end
  end
end
