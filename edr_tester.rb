require 'socket'
require 'etc'
require 'time'

class EDRTester

  def initialize(logger)
    @logger = logger
  end

  def create_file(file_name)
    File.open(file_name, "w").close
  end

  def modify_file(file_name, content)
    File.open(file_name, "a") do |file|
      file.write(content)
    end
  end

  def delete_file(file_name)
    File.delete(file_name)
  end

  def send_network_data(host, port, data)
    socket = TCPSocket.new(host, port)
    socket.write(data)
    socket.close
  end

  def run_process(exec_path)
    pid = Process.spawn(exec_path)

    activity = {
      type: "run_process",
      username: Etc.getlogin,
      process_name: File.basename(exec_path),
      process_id: pid,
      timestamp: Time.now.utc.iso8601
    }
    @logger.log_activity(activity)
  end
end