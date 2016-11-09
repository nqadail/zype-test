require_relative '../services/zype_api_session'

# Notes:
#
# It took me some time to get the video list url working properly as the PDF
# had the hyphen encoded as either an en-dash or em-dash

class VideosController < ApplicationController

  before_filter :setup


  def setup
    @app_key = 'XWny5j0V89yb1uZu6SI_D95EADV5FzBYldE9Ny0_q0GOzcWLiruPyhN-f2Pcyohf'
    if session.present?
      session[:app_key] = @app_key
    end
  end


  def list
    get_video_list( @app_key )
  end


  def show
    @video_id = params[:id]
    if session.present?
      @access_token = session[:access_token]
    else
      @access_token = nil
    end
  end


  def get_video_list( app_key )
    @videos = []
    @logged_in = session.present? && session[:access_token]
    code, video_data = ZypeApiSession.get_video_list( app_key, 0, 30 )
    if code == 200
      video_data.each do |v|
        @videos << {
          video_id: v['_id'],
          title:    v['title'],
          thumb:    v['thumbnails'][0]['url'],
          subreq:   v['subscription_required']
        }
      end
    end
  end

end
