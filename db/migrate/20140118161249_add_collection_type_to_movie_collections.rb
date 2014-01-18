class AddCollectionTypeToMovieCollections < ActiveRecord::Migration
  def change
    add_column :movie_collectionsu, :collection_type_id, :integer
  end
end
