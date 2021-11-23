class BroadcastsController < ApplicationController
    def index
        @broadcasts = Broadcast.all
        @users = User.all
    end
end
  