class HeadersConfigurator

  attr_reader :allowed

  def allow(ary)
    @allowed = ary
  end
end
