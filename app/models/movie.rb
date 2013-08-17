class Movie < ActiveRecord::Base
  attr_accessible :description, :name, :rating, :tmdb_id, :year, :imdb_db, :poster_path, :watched, :wanted, :tagged, :runtime, :trailer, :genre
  
  def update_tmdb
    if !self.tmdb_id.nil?
      update_by_tmdb_id    
    elsif !self.name.nil?
      update_by_name
    end
  end
    
  def update_by_name
    if self.name.nil?
      return
    end
    
    @movie = TmdbMovie.find(:title => self.name, :limit => 1)
    update_by_tmdb_obj @movie
  end
  
  def update_by_tmdb_id
    if !self.name.nil? and !self.poster_path.nil?
      return
    end
    
    @movie = TmdbMovie.find(:id => self.tmdb_id)
    update_by_tmdb_obj @movie
  end
  
  def update_by_tmdb_obj movie_obj
    self.name = movie_obj.title
    self.year = movie_obj.release_date[0,4].to_i
    self.rating = movie_obj.vote_average
    self.description = movie_obj.overview
    self.imdb_id = movie_obj.imdb_id
    self.poster_path = movie_obj.poster_path
    self.tmdb_id = movie_obj.id
    self.runtime = movie_obj.runtime
    if movie_obj.trailers.any?
      self.trailer = movie_obj.trailers[0].source
    end
    if movie_obj.genres.any?
      self.genre = movie_obj.genres[0].id
    end       
    if self.watched.nil?
      self.watched = false
    end
    if self.wanted.nil?
      self.wanted = false
    end
    if self.tagged.nil?
      self.tagged = false
    end
    #self.watched = false    
  end
  
end
