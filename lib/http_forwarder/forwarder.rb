# Forwards requests to registered services
module HttpForwarder
  module Forwarder
    include ActiveSupport::Configurable

    ACTIONS_MAP = {
        show: :get,
        index: :get,
        create: :post,
        update: :put,
        destroy: :delete
    }.freeze

    private

    def forward_and_render
      response = forward
      render_response(response)
    end

    def forward
      action = ACTIONS_MAP[action_name.to_sym]
      base_url = find_target
      path = request.original_fullpath
      body = request.raw_post
      headers = request.headers
      # todo clean headers
      # todo white headers config
      yield(body, path) if block_given?
      # as path is not required, it can be destroyed in yield
      body = @body if defined? @body
      path = @path if defined? @path
      HTTP.headers(
          accept: request.headers['Accept'],
          content_type: request.headers['Content-Type']
      ).request(
          action,
          "#{base_url}#{path}",
          body: body
      )
    end

    def find_target
      entries = routes.select { |hash| hash[:controller] == controller_name.to_sym }
      return entries.first[:to] if entries.one?
      action = entries.select { |hash| hash[:action] == action_name.to_sym }
      raise 'Action route was not specified for the given controller' if action.empty?
      raise 'two routes have been defined for two same actions' if action.size > 1
      action.first[:to]
    end

    def routes
      r = Forwarder.config.router.routes
      raise 'No routes specified for HttpForwarder::Forwarder' if r.nil? || r.empty?
      r
    end

    def render_response(resp)
      raw_body = resp.body.to_s
      render body: raw_body, status: resp.status, content_type: resp.content_type
    end
  end
end
