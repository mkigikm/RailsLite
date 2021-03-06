require 'byebug'

module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern          = pattern
      @http_method      = http_method
      @controller_class = controller_class
      @action_name      = action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      # byebug
      !!(req.path =~ pattern) &&
        req.request_method.downcase.to_sym == http_method
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      # byebug
      req_params = {}
      match_data = Regexp.new(pattern).match(req.path)
      match_data.names.each do |name|
        req_params[name] = match_data[name]
      end

      controller_class.new(req, res, req_params).invoke_action(action_name)
    end
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      if @nested_path
        puts "#{@nested_path}#{pattern}"
      end
      pattern = Regexp.new("#{@nested_path}#{pattern}") if @nested_path
      @routes << Route.new(pattern, method, controller_class, action_name)
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      instance_eval(&proc)
      puts routes.map(&:pattern)
    end

    def resources(resource_name)
      @nested_path = "^/#{resource_name}/(?<#{resource_name.singularize}_id>\\d+)"
      yield
      @nested_path = nil
    end

    # make each of these methods that
    # when called add route
    [:get, :post, :put, :delete].each do |http_method|
      define_method http_method do |pattern, controller_class, action_name|
        add_route pattern, http_method, controller_class, action_name
      end
    end

    # should return the route that matches this request
    def match(req)
      routes.each do |route|
        return route if route.matches?(req)
      end

      nil
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      route = match(req)

      if route
        route.run(req, res)
      else
        res.status = 404
      end
    end
  end
end
