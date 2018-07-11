# Forwards requests to registered services
module HttpForwarder
  module ForwarderController
    # TODO Target must be configurable using external config file
    # maybe load YAML and read key: value
    TARGET = { dummy: 'http://another-dummy.org' }.freeze

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
      base_url = TARGET[controller_name.to_sym]
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
