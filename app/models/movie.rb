class Movie < ActiveRecord::Base
  has_and_belongs_to_many :movie_collections
  has_and_belongs_to_many :users
  attr_accessible :description, :name, :rating, :tmdb_id, :year, :imdb_db, :poster_path, :watched, :runtime, :trailer, :genre
  
  def wikipedia
    "http://en.wikipedia.org/w/index.php?search=" + self.name.gsub(" ", "+")
  end

  #todo: handle by user  
  def is_tagged user
    user_id = 1
    if (!user.nil?)
      user_id = user.id
    end
    
    favorties = MovieCollection.where(:user_id => user_id, :collection_type_id => 4)[0].movies
    return favorties.where(:id => self.id).length == 1    
  end  
  
  #todo: handle by user
  def is_wanted user
    user_id = 1
    if (!user.nil?)
      user_id = user.id
    end  
    favorties = MovieCollection.where(:user_id => user_id, :collection_type_id => 5)[0].movies
    return favorties.where(:id => self.id).length == 1    
  end    
  
  def is_rob_favorite
    favorties = MovieCollection.where(:user_id => 1, :collection_type_id => 1)[0].movies
    return favorties.where(:id => self.id).length == 1    
  end
  
  def is_marina_favorite
    favorties = MovieCollection.where(:user_id => 2, :collection_type_id => 1)[0].movies
    return favorties.where(:id => self.id).length == 1    
  end
  
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
