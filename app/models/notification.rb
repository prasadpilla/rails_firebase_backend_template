class Notification < ApplicationRecord
  enum channel: [:sms, :email, :voice, :push]
  enum reason: []
  enum status: [:pending, :processing, :sent, :failed, :skipped]
  validates :channel, :reason, :status, presence: true
end
