require 'json'
require 'webrick'

module Phase8
  class Flash
    FLASH_COOKIE = '_rails_lite_app_flash'
    attr_reader :now

    def initialize(req)
      if cookie = req.cookies.find { |cookie| cookie.name == FLASH_COOKIE }
        @now = JSON.parse(cookies.value)
      else
        @now = {}
      end
      @fresh_keys = Set.new
    end

    def [](key)
      now[key]
    end

    def []=(key, value)
      @fresh_keys << key
      now[key] = value
    end

    def store_flash(res)
      cookie = WEBrick::Cookie.new(FLASH_COOKIE, next_flash.to_json)
      cookie.path = "/"
      res.cookies << cookie
    end

    private
    def next_flash
      @fresh_keys
      now.select { |k, v| @fresh_keys.include?(k) }
    end
  end
end
