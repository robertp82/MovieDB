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
    #@movies = Movie.where(:watched => false, :wanted => false, :tagged => false)
    @movies = Movie.where(:watched => false)
    
    render_index @movies, false, false, false
  end  
  
  def all
    @title = "All"
    #@movies = Movie.where(:wanted => false)
    @movies = Movie.all
    render_index @movies    
  end
   
  def watched
    @title = "Watched"
    @movies = Movie.where(:watched => true)    
    render_index @movies 
  end
  
  def recent_watched
    @title = "Recently Watched"
    months_from = 1
    if (params.has_key?(:months_from))
      months_from = params[:months_from].to_i
    end
    
    months_to = months_from - 1
    
    if (params.has_key?(:months_to))
      months_to = params[:months_to].to_i
    end
    
    @movies = Movie.where(:watched => true, :watched_at =>  (Time.now.midnight - months_from.month..Time.now.midnight - months_to.month + 1.day)) 
    render_index @movies 
  end
  
  def recent_added
    @title = "Recently Added"
    @movies = Movie.where(:created_at => (Time.now.midnight - 45.day..Time.now + 1.day)) 
    render_index @movies 
  end   
  
 def tagged
    @title = "Tagged"
    #@movies = Movie.where(:tagged => true, :watched => false, :wanted => false)
    user_id = 1
    if (!current_user.nil?)
      user_id = current_user.id
    end
    @movies = get_collection({ :user_id => user_id }, 4).where(:watched => false) #handle for rob/marina independently
    render_index @movies, false, false, false
  end  
  
  def wanted
    @title = "Wanted"
    user_id = 1
    if (!current_user.nil?)
      user_id = current_user.id
    end
    #@movies = Movie.where(:wanted => true)    
    @movies = get_collection({ :user_id => user_id }, 5) #handle for rob/marina independently
    render_index @movies, true, false, false, false, false 
  end
  
  def rob
    @title = "Rob's Favorite"
    #@movies = Movie.where(:rob_favorite => true)    
    @movies = get_collection({ :user_id => 1 }, 1)
    render_index @movies, false, true, false, true, false 
  end        

  def marina
    @title = "Marina's Favorite"
    #@movies = Movie.where(:marina_favorite => true)  
    @movies = get_collection({ :user_id => 2 }, 1)    
    render_index @movies, false, false, true, true, false 
  end  
  
  def id_list
    @title = "Selected"
    if (params.has_key?(:id))
      movie_ids = params[:id].split(",").map { |s| s.to_i }     
    else
      movie_ids = params[:ids]
    end
    @movies = Movie.find_all_by_id(movie_ids)
    render_index @movies 
  end    
  
  def set_user_queue  
    set_collection 2  
  end  
  
  def user_queue
    @title = "User Picks"
    show_collection params, 2
  end  
  
  def set_collection movie_queue_type_id
    if !signed_in?
      return
    end
    user_id = current_user.id  
    movie_ids = params[:id].split(",").map { |s| s.to_i }
    user = current_user
    movies = Movie.find_all_by_id(movie_ids)    
    
    movie_queues = get_movie_collections(user, movie_queue_type_id)
    
    if (movie_queues.nil?)
      mc = MovieCollection.new
      mc.user_id = user_id
      mc.name = "Default"
      mc.collection_type_id = movie_queue_type_id
      user.movie_collections.push(mc)    
      movie_queues = get_movie_collections(user, movie_queue_type_id)
    else    
      movie_queues[0].movies.clear
    end
       
    movie_queues[0].movies.push(movies)    
  
  end
  
  def get_collection params, movie_queue_type_id    
    found_picks = false
    movies = nil
    if (params.has_key?(:user_id))
      user_id = params[:user_id]
      user = User.find(user_id)
    else
      user = current_user
    end

    if (user.nil?)
      redirect_to action: 'index'
    end
    
    movie_queues = get_movie_collections(user, movie_queue_type_id)
    
    if (movie_queues.length >= 1)                 
      movies = movie_queues[0].movies
    end       
    
    movies
  end
  
  def show_collection params, movie_queue_type_id
  
    @movies = get_collection params, movie_queue_type_id
    
    if (!@movies.nil?)                   
      render_index @movies
    else
      redirect_to action: 'index'
    end  
  end
    
  def get_movie_collections user, collection_type_id
    if (user.nil?)
      return nil
    end
    
    movie_queues = user.movie_collections.where(:collection_type_id => collection_type_id)
    movie_queues  
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
    @movie = @movie.toggle(:watched)
    
    if @movie.watched
      @movie.watched_at = Time.now
    else
      @movie.watched_at = nil
    end    
    
    @movie.save
    respond_to do |f|
      f.js
    end
  end
  
  
 def toggle_want
    toggle_collection current_user, 5, false
    
    @movie = Movie.find(params[:id])
    
    #TODO: auto-tag when toggling want?
    if !@movie.is_wanted current_user
      toggle_collection current_user, 4, false
    end
    
    respond_to do |f|
        f.js
    end    
    
  end
  
  def toggle_tag   
    toggle_collection current_user, 4
  end    
  
  def toggle_rob
    user = User.find(1)
    toggle_favorite user
  end 
  
  def toggle_marina
    user = User.find(2)
    toggle_favorite user
  end  

  def toggle_favorite user
    toggle_collection user, 1  
  end
  
  def toggle_collection user, collection_type_id, respond_false = false
    @movie = Movie.find(params[:id])
    movie_id = params[:id]
    
    movie_collections = get_movie_collections(user, collection_type_id)
    favorite_movies = movie_collections[0].movies
    movie_exists = favorite_movies.where(:id => movie_id).length == 1
    if (movie_exists)
      favorite_movies.delete(@movie)
    else
      favorite_movies.push(@movie)
    end
    
    if (respond_false.nil?)
      respond_to do |f|
        f.js
      end
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
