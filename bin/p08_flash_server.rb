require 'webrick'
require_relative '../lib/phase8/controller_base'
require_relative '../lib/phase6/router'


# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

class SetFlashController < Phase8::ControllerBase
  def index
    flash["flash_value"] = params[:flash_id]
    render_content("set flash", "text/text")
  end

  def show
    render_content "show", "text/text"
  end
end

class ReadFlashController < Phase8::ControllerBase
  def index
    render_content("Your flash is #{flash["flash_value"]}", "text/text")
  end
end

router = Phase6::Router.new
router.draw do
  get Regexp.new("^/flash$"), ReadFlashController, :index
  get Regexp.new("^/flash/(?<flash_id>\\d+)$"), SetFlashController, :index
  get Regexp.new("^/flash/show$"), SetFlashController, :show
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
