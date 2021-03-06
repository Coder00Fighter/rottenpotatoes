class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #default
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    
    if params['commit'] != nil && params['ratings'] == nil
      params['ratings'] = Hash[@all_ratings.collect { |item| [item, "1"] } ]
    end
    
    #check box
    @ratings = params['ratings']
    if @ratings.present?
      session['ratings'] = @ratings
    end
    
    # sorting
    @sorted_by = params['sorted_by']
    if @sorted_by.present?
      session['sorted_by'] = @sorted_by
    end
    
    # render
    @ratings = session['ratings']
    if @ratings.present?
      @ratings_to_show = @ratings.keys
      @movies = Movie.with_ratings(@ratings_to_show)
    end
    
    @sorted_by = session['sorted_by']
    if @sorted_by.present?
      @movies = @movies.order(@sorted_by)
      if @sorted_by == 'title'
        @title_class = 'hilite'
      elsif @sorted_by == 'release_date'
        @release_date_class = 'hilite'
      else
        print "Unknown Sorting Key"
      end  
    end   
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
