class CreateMoviesMovieCollectionsTable < ActiveRecord::Migration
 def self.up
    create_table :movie_collections_movies, :id => false do |t|
        t.references :movie_collection
        t.references :movie
    end
    add_index :movie_collections_movies, [:movie_collection_id, :movie_id], :name => 'movie_coll_index'
    add_index :movie_collections_movies, :movie_collection_id, :name => 'movie_coll_index_by_id'
  end

  def self.down
    drop_table :movie_collections_movies
  end  
end
