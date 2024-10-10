require 'socket'

class EDRTester

  def initialize
    # logger will go here later
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

  def run_process(command)
    Kernel.system(command)
  end
end