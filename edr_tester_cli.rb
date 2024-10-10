#!/usr/bin/env ruby

require 'optparse'
require_relative 'activity_logger'
require_relative 'edr_tester'

DEFAULT_LOG_FILE_PATH = "activity_log.json"

def parse_args
  options = {}
  OptionParser.new do |opts|
    opts.on("-a", "--activity ACTIVITY") do |arg|
      options[:activity] = arg
    end

    opts.on("--file FILE") do |arg|
      options[:file_name] = arg
    end

    opts.on("--path PATH") do |arg|
      options[:path] = arg
    end

    opts.on("--content CONTENT") do |arg|
      options[:content] = arg
    end

    opts.on("--host HOST") do |arg|
      options[:host] = arg
    end

    opts.on("--port PORT") do |arg|
      options[:port] = arg
    end

    opts.on("--data DATA") do |arg|
      options[:data] = arg
    end

    opts.on("--log-file LOG_FILE") do |arg|
      options[:log_file] = arg
    end
  end.parse!

  options
end

def run
  options = parse_args
  log_file = options[:log_file] || DEFAULT_LOG_FILE_PATH
  logger = ActivityLogger.new(log_file)
  tester = EDRTester.new(logger)

  case options[:activity]
  when "create_file"
    tester.create_file(options[:file_name])
  when "modify_file"
    tester.modify_file(options[:file_name], options[:content])
  when "delete_file"
    tester.delete_file(options[:file_name])
  when "send_network_data"
    tester.send_network_data(options[:host], options[:port], options[:data])
  when "run_process"
    tester.run_process(options[:path])
  else
    puts "unknown command"
  end
end

run
