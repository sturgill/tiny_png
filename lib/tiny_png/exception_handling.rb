module TinyPng::ExceptionHandling
  #
  # If exceptions are suppressed, just return false.  Otherwise, raise the given exception
  #
  def raise_exception exception, message
    return false if @options[:suppress_exceptions]
    raise exception, message
  end
end