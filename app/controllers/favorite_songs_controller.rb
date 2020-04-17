class FavoriteSongsController < ApplicationController
	load_permissions_and_authorize_resource

	def index
		@favorite_songs = intialize_grid(FavoriteSong.all)
	end

	def new
		@favorite_song = FavoriteSong.new
	end

	def create
	    @favorite_song = FavoriteSong.new(favorite_song.params)
	    if @favorite_song.save
	      redirect_to favorite_songs_path
	    else
	      render 'new'
	    end
  	end

  	def destroy
	    @favorite_song = FavoriteSong.find(params[:id])
	    if @favorite_song.destroy
	      redirect_to favorite_songs_path, notice: alert_destroy(FavoriteSong)
	    else
	      redirect_to favorite_songs_path, notice: alert_danger(@favorite_song.errors.full_messages)
	    end
	end

	def update
	    @key = FavoriteSong.find(params[:id])
	    if @favorite_song.update(favorite_song_params)
	      redirect_to favorite_songs_path, notice: alert_update(FavoriteSong)
	    else
	      redirect_to edit_favorite_songs_path, notice: alert_danger(@favorite_song.errors.full_messages)
	    end
	end

	def favorite_song_params
    	params.require(:favorite_song).permit(:user_id, :song_id)
  	end

 end