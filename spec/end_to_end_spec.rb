require 'rspec'
require 'json'
require 'pry'

RSpec.describe 'EDRTester CLI End-to-End' do
  let(:script_path) { File.expand_path("./edr_tester_cli.rb").gsub(" ", "\\ ") }
  let(:log_file) { "e2e_test_activity_log.json" }

  after do
    File.delete(log_file) if File.exist?(log_file)
  end

  it 'executes run_process action from CLI and logs activity' do
    executable_path = '/bin/ls'
    command_line_args = [
      script_path,
      '-a', 'run_process',
      '--path', executable_path,
      '--log-file', log_file
    ]

    full_command = "ruby #{command_line_args.join(" ")}"
    system(full_command)

    expect(File.exist?(log_file)).to eq(true)

    activities = []
    File.foreach(log_file).with_index do |line|
      activities << JSON.parse(line)
    end

    expect(activities.size).to eq(1)
    activity = activities.first
    expect(activity['type']).to eq('run_process')
    expect(activity['process_name']).to eq('ls')

  end
end