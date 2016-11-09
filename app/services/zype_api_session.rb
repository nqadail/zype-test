require 'curb'

class ZypeApiSession

  attr_reader :access_token

  def initialize ( user )
    @client_id     = user.client_id
    @client_secret = user.client_secret
    @username      = user.username
    @password      = user.password
  end


  def fetch_token
    url = "https://login.zype.com/oauth/token/?client_id=#{@client_id}" +
          "&client_secret=#{@client_secret}" +
          "&username=#{@username}" +
          "&password=#{@password}" +
          '&grant_type=password'

    code, data = http_post( url )

    @access_token = data['access_token']
  end


  def self.get_video_list( app_key, page, per_page )
    # Although not within the scope of the challenge, it seems reasonable
    # to support pagination in the future. This would require persisting
    # an instance of this object across requests

    url = "https://api.zype.com/videos?app_key=#{app_key}" +
          "&page=#{page}&per_page=#{per_page}"

    code, response = http_get( url )

    videos = response['response']

    [code, videos]

  end


  protected


  def self.http_get( url )
    code = 0
    data = ''
    c = Curl::Easy.http_get( url )

    code = c.response_code

    if code == 200 && c.body
      data = JSON.parse( c.body )
    end

    [code, data]
  end


  def http_post( url )
    code = 0
    data = ''
    c = Curl::Easy.http_post( url )

    code = c.response_code

    if code == 200 && c.body
      data = JSON.parse( c.body )
    end

    [code, data]
  end

end
