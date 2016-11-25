require 'rulers/version'
require 'rulers/routing'
require 'rulers/util'
require 'rulers/dependencies'

module Rulers
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404,
                { 'Content-Type' => 'text/html' }, []]
      elsif env['PATH_INFO'] == '/'
        # File.open(File.join(File.dirname(__FILE__), '..', 'public', 'index.html'), 'r') do |file|
        #   return [200, { 'Context-Type' => 'text/html' }, [file.read]]
        # end
        # return [302, { 'Location' => '/quotes/a_quote', 'Content-Type' => 'text/html' }, ['Moved Permanently']]
        controller = HomeController.new(env)
        text = controller.send('index')
        return [200, { 'Content-Type' => 'text/html' }, [text]]
      end

      begin
        klass, act = get_controller_and_action(env)
        controller = klass.new(env)
        text = controller.send(act)
        [200, { 'Content-Type' => 'text/html' }, [text]]
      rescue
        text = '<p>An error occurred.</p>'
        [400, { 'Content-Type' => 'text/html' }, [text]]
      end
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end

  class HomeController < Controller
    def index
      'Hello from index.'
    end
  end
end
