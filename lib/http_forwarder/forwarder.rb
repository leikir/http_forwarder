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

    def forward(opts = {})
      before = opts[:before]
      after = opts[:after]
      @request = request.dup
      if before
        send(before, @request) if respond_to? before
      end
      response = send_request
      if after
        send(after, response) if respond_to? after
      end
      render_response(response)
    end

    def send_request
      action = ACTIONS_MAP[action_name.to_sym]
      base_url = find_target
      path = @request.original_fullpath
      HTTP.headers(
          accept: request.headers['Accept'],
          content_type: request.headers['Content-Type']
      ).send(
          action,
          "#{base_url}#{path}",
          body: @request.raw_post
      )
    end

    def find_target
      entries = routes.select { |hash| hash[:controller] == controller_name.to_sym }
      return entries.first[:to] if entries.one?
      action = entries.select { |hash| hash[:action] == action_name.to_sym }
      raise 'Action route was not specified for the given controller' if action.empty?
      action.first[:to]
    end

    def routes
      r = Forwarder.config.routes
      raise 'No routes specified for HttpForwarder::Forwarder' if r.empty?
      r
    end

    def render_response(resp)
      raw_body = resp.body.to_s
      if raw_body.present?
        render body: raw_body, status: resp.status, content_type: resp.content_type
      else
        head resp.status and return
      end
    end
  end
end
