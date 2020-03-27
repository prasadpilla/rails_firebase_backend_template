class ApplicationJob
  include ExceptionHandlers

  def self.logger
    @logger ||= Logger.new("log/#{self.name.demodulize.underscore}.log", level: Rails.logger.level)
  end

  def logger
    @logger ||= Logger.new("log/#{self.class.name.demodulize.underscore}.log", level: Rails.logger.level)
  end
end
