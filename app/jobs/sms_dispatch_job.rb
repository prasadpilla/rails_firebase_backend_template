class SmsDispatchJob < ApplicationJob
  include Sidekiq::Worker

  def perform(mobile, message)
    Msg91ruby::API.new(ENV['MSG91_AUTH_KEY'], ENV['MSG91_SENDER_ID']).send(mobile, message, 4)
  rescue StandardError => e
   log_and_reraise(e)
  end
end