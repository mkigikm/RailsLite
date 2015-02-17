require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params
      if req.query_string
        @params.merge!(parse_www_encoded_form(req.query_string))
      end
      if req.body
        @params.merge!(parse_www_encoded_form(req.body))
      end
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      {}.tap do |hash|
        URI::decode_www_form(www_encoded_form).map do |(key, value)|
          recursive_nesting(parse_key(key), value, hash)
        end
      end
    end

    def recursive_nesting(keys, value, cur_hash)
      key = keys.first

      if keys.count == 1
        cur_hash[key] = value
      else
        cur_hash[key] ||= {}
        recursive_nesting(keys.drop(1), value, cur_hash[key])
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split /\]\[|\[|\]/
    end
  end
end
