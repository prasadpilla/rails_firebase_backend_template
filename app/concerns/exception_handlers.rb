module ExceptionHandlers
  def log_and_reraise(exception, context_params = {})
    log_exception(exception, context_params)
    raise exception
  end

  def log_and_report(exception, context_params = {}, namespace='')
    log_exception(exception, context_params)
    report_exception(exception, context_params, namespace, caller_locations.first.label)
  end

  def log_exception(exception, context_params = {})
    logger.error(exception.message)
    logger.error("context_params: #{context_params}")
    logger.error(exception.backtrace.try(:join, "\n"))
  end

  def report_exception(exception, context_params = {}, namespace = '', caller = caller_locations.first.label)
    Appsignal.send_error(exception) do |transaction|
      transaction.params = context_params
      transaction.set_namespace(namespace)
      transaction.set_action("#{self.class}##{caller}")
    end
  end
end
