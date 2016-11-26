require 'erubis'

module Rulers
  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def render(view_name, locals = {})
      filename = File.join 'app', 'views', controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      self.instance_variables.each { |variable| locals[variable] = self.instance_variable_get variable }
      eruby.result locals
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/, ''
      Rulers.to_underscore klass
    end

    def request
      @_request ||= Rack::Request.new @env
    end
  end
end
