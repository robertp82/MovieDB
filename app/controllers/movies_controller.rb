class MoviesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :delete, :edit, :toggle_watch, :toggle_tag, :toggle_want, :toggle_rob, :toggle_marina]
  # GET /movies
  # GET /movies.json
  
  
  def render_index movies, show_wanted = false, show_rob = true, show_marina = true, show_tagged = true, show_watched = true
    @show_wanted = show_wanted
    @show_rob = show_rob
    @show_marina = show_marina
    @show_tagged = show_tagged
    @show_watched = show_watched  
    respond_to do |format|

      format.html { render :index }
      format.json { render json: @movies }
    end
  end
  
  def index    
    if signed_in?
      redirect_to action: 'tagged'    
    else
      redirect_to action: 'rob'
    end
  end
  
  def unwatched
    @title = "Unwatched"
    @movies = Movie.where(:watched => false, :wanted => false, :tagged => false)
    render_index @movies, false, false, false
  end  
  
  def all
    @title = "All"
    @movies = Movie.where(:wanted => false)
    render_index @movies    
  end
  
  def tagged
    @title = "Tagged"
    @movies = Movie.where(:tagged => true, :watched => false, :wanted => false)    
    render_index @movies, false, false, false
  end
  
  def watched
    @title = "Watched"
    @movies = Movie.where(:watched => true)    
    render_index @movies 
  end
  
  def recent_watched
    @title = "Recently Watched"
    @movies = Movie.where(:watched => true, :watched_at =>  (Time.now.midnight - 30.day..Time.now + 1.day)) 
    render_index @movies 
  end     
  
  def wanted
    @title = "Wanted"
    @movies = Movie.where(:wanted => true)    
    render_index @movies, true, false, false, false, false 
  end

  def rob
    @title = "Rob's Favorite"
    @movies = Movie.where(:rob_favorite => true)    
    render_index @movies, false, true, false, true, false 
  end        

  def marina
    @title = "Marina's Favorite"
    @movies = Movie.where(:marina_favorite => true)    
    render_index @movies, false, false, true, true, false 
  end     

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end
    

  # GET /movies/new
  # GET /movies/new.json
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(params[:movie])
    #@movie = Movie.create(movie_params)
    
    @movie.update_tmdb       

    respond_to do |format|
      if !@movie.tmdb_id.nil? and @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render json: @movie, status: :created, location: @movie }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.json
  def update
    @movie = Movie.find(params[:id])    

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def toggle_watch
    @movie = Movie.find(params[:id])
    if !@movie.watched
      @movie.watched_at = Time.now
    else
      @movie.watched_at = nil
    end    
    @movie.toggle!(:watched)
    respond_to do |f|
      f.js
    end
  end
  
  def toggle_tag
    @movie = Movie.find(params[:id])
    @movie.toggle!(:tagged)  
    respond_to do |f|
      f.js
    end
  end  
  
 def toggle_want
    @movie = Movie.find(params[:id])
    @movie.toggle!(:wanted)  
    respond_to do |f|
      f.js
    end
  end    
  
  def toggle_rob
    @movie = Movie.find(params[:id])
    @movie.toggle!(:rob_favorite)  
    respond_to do |f|
      f.js
    end
  end  

  def toggle_marina
    @movie = Movie.find(params[:id])
    @movie.toggle!(:marina_favorite)  
    respond_to do |f|
      f.js
    end
  end    

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end
  
  private
    # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    #def movie_params
      #params.require(:movie).permit(:description, :name, :rating, :tmdb_id, :year, :imdb_db, :poster_path, :watched, :wanted, :tagged)
    #end  
end
