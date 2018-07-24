class RouterConfigurator

  attr_reader :routes

  def initialize
    @routes = []
  end

  def forward(controller)
    @controller = controller.to_sym
    self
  end

  def on(action)
    @action = action.to_sym
    self
  end

  def to(url)
    @url = url.to_s
    add_route
    self
  end

  private

  def add_route
    @routes << { controller: @controller, to: @url } and return if @action.nil?
    @routes << { controller: @controller, action: @action, to: @url }
  end
end
