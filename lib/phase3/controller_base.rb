require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require 'byebug'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      file_name = "views/#{self.class.name.underscore}/#{template_name}.html.erb"
      template = File.read(file_name)
      rendered_template = ERB.new(template).result(binding)
      render_content(rendered_template, 'text/html')
    end

    def render_partial(partial_name, options={})
      file_name = "views/#{self.class.name.underscore}/_#{partial_name}.html.erb"
      template = File.read(file_name)
      template_binding = binding

      options[:locals].each do |local, value|
        template_binding.local_variable_set(local, value)
      end

      rendered_template = ERB.new(template).result(template_binding)
    end
  end
end
