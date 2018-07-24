# Forwards requests to registered services
module HttpForwarder
  module Forwarder
    private

    include ActiveSupport::Configurable

    ACTIONS_MAP = {
      show: :get,
      index: :get,
      create: :post,
      update: :put,
      destroy: :delete
    }.freeze

    def forward_and_render
      response = forward
      render_response(response)
    end

    def forward
      action = ACTIONS_MAP[action_name.to_sym]
      base_url = find_target
      path = request.original_fullpath
      body = request.raw_post
      headers = allowed_headers

      yield(body, path, headers) if block_given?

      # as path is not required, it can be destroyed in yield
      body = @body if defined? @body
      path = @path if defined? @path
      headers = @headers if defined? @headers
      HTTP.headers(headers).request(
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
      Forwarder.config.router.routes.presence ||
        raise('No routes specified for HttpForwarder::Forwarder')
    end

    def allowed_headers
      if Forwarder.config.headers.allowed.present?
        extracted_headers
      else
        request.headers
      end
    end

    # I can't use slice here since the keys are processed in a private method
    def extracted_headers
      Forwarder.config.headers.allowed.each_with_object({}) do |key, h|
        h[key] = request.headers[key]
      end
    end

    def render_response(resp)
      raw_body = resp.body.to_s
      render body: raw_body, status: resp.status, content_type: resp.content_type
    end
  end
end
