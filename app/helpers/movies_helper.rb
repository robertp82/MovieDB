module MoviesHelper  
  
  #This was used to seed the database with dumps of file trees of existing movies
  #You could modify the movie parsing and use it. It's reading in a "Movie Title (YEAR).ext" format.
  def self.add_movies file_path, watched
    File.open(file_path, "r").each_line do |line|
      title = line[0...-13]
      movie = Movie.new()
      movie.name = title
      movie.update_by_name
      movie.watched = watched
      begin
        movie.save
      rescue
        puts "fail" + line
      end
    end
  end   
  
  
  #This method is used to refresh data from themoviedb
  def self.update_all_movies
    movies = Movie.all
    movies.each do | m |
      if m.runtime.nil?
        mov = TmdbMovie.find(:id => m.tmdb_id)
        m.update_by_tmdb_obj mov     
        #m.update_by_name      
        #m.watched = true
        begin
          m.save
        rescue
          put "failed to save"
        end
      end
    end
  end
  
end
