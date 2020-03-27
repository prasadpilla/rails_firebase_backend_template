require 'sidekiq/testing'
require 'shoulda/matchers'
require 'sidekiq/testing'
require 'webmock/rspec'
require 'simplecov'
require 'rails_helper'
require 'helpers'

Sidekiq::Testing.inline!
WebMock.enable!

SimpleCov.start do
  add_filter '/config'
  add_filter '/spec/'

  add_group 'Controllers',         'app/controllers'
  add_group 'Helpers',  'app/helpers'
  add_group 'Jobs',  'app/jobs'
  add_group 'Mailers',     'app/mailers'
  add_group 'Models',      'app/models'
  add_group 'Workers',   'app/workers'
  add_group 'Connectors',   'lib/connectors'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = :defined

  config.before(:each) do
    Sidekiq::Worker.clear_all
    ActionMailer::Base.deliveries.clear
  end

  config.before(:suite) do
    Rails.application.load_seed
  end
end
