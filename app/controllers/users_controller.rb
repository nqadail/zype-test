require_relative '../services/zype_api_session'
#require_relative '../models/users'

class UsersController < ApplicationController

  before_filter :get_client_info, :only => :authenticate


  def get_client_info
    # normally, the client_id and secret would be stored in the DB with possibly
    # a relation for different clients. This functionality can easily be added
    # later
    @client_id     = '61255480307354ebd4d094482f2483adec9942637979aa5c3963ecbac469f943'
    @client_secret = '926e632b2aa9758f60dbdf2f8de13bebd9a04dfd602de4c257b3f8b4a97cf0b8'
  end


  def login
    if params[:error]
      @message = 'Invalid login.'
    end

    if params[:video_id]
      if session.present?
        session[:video_id] = params[:video_id]
        redirect_to '/login'
      end
    end
  end


  def authenticate
    @user = User.new({
      client_id:     @client_id,
      client_secret: @client_secret,
      username:      params[:user],
      password:      params[:password]
    })

    zas = ZypeApiSession.new( @user )

    access_token = zas.fetch_token

    if !access_token.nil?

      if session.present?
        session[:access_token] = access_token
        video_id = session[:video_id]
        session[:video_id] = nil
      end

      if video_id
        redirect_to "/videos/show/#{video_id}"
      else
        redirect_to '/'
      end
    else
      redirect_to '/login/error'
    end
  end
end
