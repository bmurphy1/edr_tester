require 'rspec'
require 'json'
require_relative 'activity_logger'

RSpec.describe ActivityLogger do
  let(:log_file) { "test_activity_log.json" }
  let(:logger) { ActivityLogger.new(log_file) }

  after do
    File.delete(log_file) if File.exist?(log_file)
  end

  it "saves log activity to a file" do
    activity = { type: "big_bang", foo: "bar" }

    logger.log_activity(activity)

    expect(File.exist?(log_file)).to eq(true)
    parsed_file = JSON.parse(File.read(log_file))
    expect(parsed_file).to eq(activity)
  end
end