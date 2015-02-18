require_relative '../phase8/controller_base'
require_relative './route_helper'

module Phase9
  class ControllerBase < Phase6::ControllerBase
    include RouteHelper
  end
end
