require 'rulers/version'
require 'rulers/routing'
require 'rulers/util'
require 'rulers/dependencies'
require 'rulers/controller'
require 'rulers/file_model'

module Rulers
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, { 'Content-Type' => 'text/html' }, []]
      elsif env['PATH_INFO'] == '/'
        controller = HomeController.new(env)
        text = controller.send('index')
        return [200, { 'Content-Type' => 'text/html' }, [text]]
      end

      begin
        klass, act = get_controller_and_action(env)
        controller = klass.new(env)
        text = controller.send(act)
        r = controller.get_response(act)
        if r
          [r.status, r.headers, [r.body].flatten]
        else
          [200, { 'Content-Type' => 'text/html' }, [text]]
        end
      rescue StandardError => e
        text = '<p>An error occurred.</p>'
        text += "<p>#{e.message}</p>"
        [400, { 'Content-Type' => 'text/html' }, [text]]
      end
    end
  end
end
