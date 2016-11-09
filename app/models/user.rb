# since there is no need to persist this particular model to the database,
# this is not an AR model but a simple class

class User
  attr_reader :username
  attr_reader :password
  attr_reader :client_id
  attr_reader :client_secret

  def initialize( params )
    @client_id     = params[:client_id]
    @client_secret = params[:client_secret]
    @username      = params[:username]
    @password      = params[:password]
  end

end