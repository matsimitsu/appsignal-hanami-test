module Api
  module Helpers

    def self.included(action)
      action.class_eval do
        handle_exception ::Exception => :render_unknown_exception
      end
    end

    def render_unknown_exception(exception)
      Hanami.logger.error(exception.message)
      ::Appsignal.set_error(exception)
      render_error_json
    end

    def render_error_json(msg = 'Unknown server side error', code = 500)
      data = { errors: msg }
      render_json(data, code)
    end

    def render_json(data, code)
      data ||= {}
      halt(code, Oj.dump(data, mode: :compat))
    end
  end
end
