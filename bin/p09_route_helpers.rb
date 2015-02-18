require 'webrick'
require_relative '../lib/phase9/controller_base'
require_relative '../lib/phase6/router'


# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

class MyController < Phase9::ControllerBase
  def create
    render_content("hello", "text/text")
  end

  def show
    render :forms
  end
end

router = Phase6::Router.new
router.draw do
  post Regexp.new("^/auth_test$"), MyController, :create
  get  Regexp.new("^/auth_test$"), MyController, :show
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
