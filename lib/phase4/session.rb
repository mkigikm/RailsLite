require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      if cookie = req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }
        @session = JSON.parse(cookie.value)
      else
        @session = {authenticity_token: SecureRandom.urlsafe_base64(16)}
      end
    end

    def [](key)
      @session[key]
    end

    def []=(key, val)
      @session[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = WEBrick::Cookie.new('_rails_lite_app', @session.to_json)
      cookie.path = "/"
      res.cookies << cookie
    end
  end
end
