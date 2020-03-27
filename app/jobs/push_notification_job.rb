require 'fcm'

class PushNotificationJob < ApplicationJob
  include Sidekiq::Worker

  def perform(notification_id, options, notification_tokens)
    current_time = Time.now
    notification = Notification.find(notification_id)
    if FCM.new(ENV['fcm_server_key']).send(notification_tokens, options)[:status_code] == 200
      notification.update!(time: current_time, status: :sent)
    else
      log_and_report(StandardError.new('Notification failure'),
                     {options: options, notification_tokens: notification_tokens}, 'background')
      notification.update!(time: current_time, status: :failed)
    end
  rescue StandardError => e
    log_and_report(e, {notification: notification.try(:inspect),
                       options: options, notification_tokens: notification_tokens}, 'background')
  end
end
