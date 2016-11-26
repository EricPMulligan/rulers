require 'erubis'
require 'rulers/file_model'
require 'rack/request'

module Rulers
  class Controller
    include Rulers::Model

    def initialize(env)
      @env = env
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub /Controller$/, ''
      Rulers.to_underscore klass
    end

    def env
      @env
    end

    def get_response(action)
      render(action) unless @response
      @response
    end

    def params
      request.params
    end

    def request
      @_request ||= Rack::Request.new @env
    end

    def render(*args)
      action, locals = args
      locals = {} unless locals
      filename = File.join 'app', 'views', controller_name, "#{action}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      self.instance_variables.each { |variable| locals[variable] = self.instance_variable_get variable }
      text = eruby.result locals
      response(text)
    end

    def response(text, status = 200, headers = {})
      raise 'Already responded!' if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end
  end
end
