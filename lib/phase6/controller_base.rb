require_relative '../phase5/controller_base'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      # byebug
      if req.request_method == "POST"
        unless params["authenticity_token"] == session["authenticity_token"]
          raise "Invalid authenticity token"
        end
      end
      send(name)
    end
  end
end
