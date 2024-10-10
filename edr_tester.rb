require 'socket'
require 'etc'
require 'time'

class EDRTester

  def initialize(logger)
    @logger = logger
  end

  def create_file(file_name)
    File.open(file_name, "w").close

    activity = {
      type: "file_activity",
      descriptor: "create",
      file_path: file_name,
      username: Etc.getlogin,
      process_name: $0,
      process_command_line: $0 + ' ' + ARGV.join(' '),
      process_id: Process.pid,
      timestamp: Time.now.utc.iso8601
    }
    @logger.log_activity(activity)
  end

  def modify_file(file_name, content)
    File.open(file_name, "a") do |file|
      file.write(content)
    end

    activity = {
      type: "file_activity",
      descriptor: "modify",
      file_path: file_name,
      username: Etc.getlogin,
      process_name: $0,
      process_command_line: $0 + ' ' + ARGV.join(' '),
      process_id: Process.pid,
      timestamp: Time.now.utc.iso8601
    }
    @logger.log_activity(activity)
  end

  def delete_file(file_name)
    File.delete(file_name)

    activity = {
      type: "file_activity",
      descriptor: "delete",
      file_path: file_name,
      username: Etc.getlogin,
      process_name: $0,
      process_command_line: $0 + ' ' + ARGV.join(' '),
      process_id: Process.pid,
      timestamp: Time.now.utc.iso8601
    }
    @logger.log_activity(activity)
  end

  def send_network_data(host, port, data)
    socket = TCPSocket.new(host, port)
    bytes_sent = socket.write(data)
    socket.close

    activity = {
      type: "send_network_data",
      username: Etc.getlogin,
      destination_address: host,
      destination_port: port,
      source_address: socket.local_address.ip_address,
      source_port: socket.local_address.ip_port,
      bytes_sent: bytes_sent,
      protocol: "TCP",
      process_name: $0,
      process_command_line: $0 + ' ' + ARGV.join(' '),
      process_id: Process.pid,
      timestamp: Time.now.utc.iso8601
    }
    @logger.log_activity(activity)
  end

  def run_process(exec_path)
    pid = Process.spawn(exec_path)

    activity = {
      type: "run_process",
      username: Etc.getlogin,
      process_name: File.basename(exec_path),
      process_command_line: $0 + ' ' + ARGV.join(' '),
      process_id: pid,
      timestamp: Time.now.utc.iso8601
    }
    @logger.log_activity(activity)
  end
end