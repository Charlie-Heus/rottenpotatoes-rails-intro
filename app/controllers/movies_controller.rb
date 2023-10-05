class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
		@all_ratings = Movie.all_ratings
		@ratings_to_show = params[:ratings].present? ? params[:ratings].keys : @all_ratings
		# sorted = params[:sorted]
    session[:ratings] = @ratings_to_show

    if params[:sorted].present? && @ratings_to_show.present?
      @movies = Movie.where(rating: @ratings_to_show).order(params[:sorted])
    elsif @ratings_to_show.present?
      @movies = Movie.where(rating: @ratings_to_show)
    else
      @movies = []
    end 


		# if params[:ratings] 
			# @ratings_to_show = params[:ratings].keys()

		# elsif
			# @ratings_to_show = session[:ratings]
		# else
			# @ratings_to_show = @all_ratings

		# end

		# sorted = params[:sorted]

		# if @ratings_to_show.present?
			# @movies = Movie.where(rating: @ratings_to_show).order(sorted)
		# else
      # @movies = []
			# @movies = Movie.all.order(sorted)
		# end

		# if @ratings_to_show.present?
			# @movies = Movie.where(rating: @ratings_to_show).order(@sorted_column)
		# else
			# @movies = Movie.all
		# end

    # Debugging output 
    # puts "params[:sorted]: #{params[:sorted]}"
    # puts "@sorted_column: #{@sorted_column}"
    # puts "SQL Query: #{@movies.to_sql}"

  end

  # def set_sorted_column
    # @sorted_column = params[:sorted] if params[:sorted].present?
  # end

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