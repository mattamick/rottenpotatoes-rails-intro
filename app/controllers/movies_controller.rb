class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.uniq.pluck(:rating)
    @checked_ratings=['','']

    # If no filters, check all on index.
    if session[:ratings] == nil
      @checked_ratings = ['PG-13', 'PG', 'G', 'R']
    end


    if params[:ratings] == nil && session[:ratings] != nil
      if params[:sort_by] == nil
        redirect_to movies_path(ratings: session[:ratings], sort_by: session[:sort_by]) and return
      else
        redirect_to movies_path(ratings: session[:ratings], sort_by: params[:sort_by]) and return
      end
    end

    if session[:ratings] != params[:ratings] && params[:ratings] != nil
      selected_ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    else
      selected_ratings = session[:ratings]
    end

    #select movies based on filter
    if selected_ratings != nil
      @checked_ratings = selected_ratings.keys
      @movies = Movie.all.select {|m| @checked_ratings.include?(m.rating)}
    end

    # sorting and highlight the sorted column
    @hilite = ['','']


    if params[:sort_by] == nil && session[:sort_by] != nil
      redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
    else
      if params[:sort_by] == "title"
        @movies = @movies.sort {|a, b| a.title.downcase <=> b.title.downcase}
        @hilite[0] = 'hilite'
        session[:sort_by] = 'title'
      elsif params[:sort_by] == "release_date"
       @movies = @movies.sort {|a,b| a.release_date <=> b.release_date}
       @hilite[1] = 'hilite'
       session[:sort_by] = 'release_date'
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

end
