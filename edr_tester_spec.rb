require 'rspec'
require_relative './edr_tester'

RSpec.describe EDRTester do

  let(:logger) { instance_double('ActivityLogger') }
  subject { EDRTester.new(logger) }

  before do
    allow(logger).to receive(:log_activity)
  end

  context "file creation" do
    let(:file_name) { "test_file_creation.txt" }

    after do
      File.delete(file_name) if File.exist?(file_name)
    end

    it "creates a file of specified type and location" do
      subject.create_file(file_name)

      expect(File.exist?(file_name)).to be true
    end

    it "logs the desired attributes" do
      subject.create_file(file_name)

      expect(logger).to have_received(:log_activity)do |args|
        expect(args[:type]).to eq("file_activity")
        expect(args[:descriptor]).to eq("create")
        expect(args[:file_path]).to eq(file_name)
        expect(args[:username]).to eq(Etc.getlogin)
        expect(args[:process_name]).to eq($0)
        expect(args[:process_command_line]).to eq($0 + ' ' + ARGV.join(' '))
        expect(args[:process_id]).to eq(Process.pid)
        expect(args[:timestamp]).to be_a(String)
      end
    end
  end

  context "file modification" do
    let(:file_name) { "test_file_modification.txt" }
    let(:content) { "Content of this file." }

    around do |example|
      File.open(file_name, "w") do |file|
        file.write(content)
      end
      example.run
      File.delete(file_name)
    end

    it "appends a file with specified content" do
      subject.modify_file(file_name, " New Content.")

      expect(File.read(file_name)).to eq(content + " New Content.")
    end

    it "logs the desired attributes" do
      subject.modify_file(file_name, " New Content.")

      expect(logger).to have_received(:log_activity)do |args|
        expect(args[:type]).to eq("file_activity")
        expect(args[:descriptor]).to eq("modify")
        expect(args[:file_path]).to eq(file_name)
        expect(args[:username]).to eq(Etc.getlogin)
        expect(args[:process_name]).to eq($0)
        expect(args[:process_command_line]).to eq($0 + ' ' + ARGV.join(' '))
        expect(args[:process_id]).to eq(Process.pid)
        expect(args[:timestamp]).to be_a(String)
      end
    end
  end

  context "file deletion" do
    let(:file_name) { "test_file_deletion.txt" }

    before do
      File.open(file_name, "w").close
    end

    it "deletes a specified file" do
      subject.delete_file(file_name)

      expect(File.exist?(file_name)).to be false
    end

    it "logs the desired attributes" do
      subject.delete_file(file_name)

      expect(logger).to have_received(:log_activity)do |args|
        expect(args[:type]).to eq("file_activity")
        expect(args[:descriptor]).to eq("delete")
        expect(args[:file_path]).to eq(file_name)
        expect(args[:username]).to eq(Etc.getlogin)
        expect(args[:process_name]).to eq($0)
        expect(args[:process_command_line]).to eq($0 + ' ' + ARGV.join(' '))
        expect(args[:process_id]).to eq(Process.pid)
        expect(args[:timestamp]).to be_a(String)
      end
    end
  end

  context "network activity" do
    let(:host) { "localhost"}
    let(:port) { 9001 }
    let(:data) { "I'm on the network." }
    let(:mock_socket) { instance_double(TCPSocket) }

    before do
      allow(TCPSocket).to receive(:new).with(host, port).and_return(mock_socket)
      allow(Process).to receive(:pid).and_return(789)
      allow(mock_socket).to receive(:write).with(data).and_return(data.bytesize)
      allow(mock_socket).to receive(:close)
      allow(mock_socket).to receive_message_chain(:local_address, :ip_address).and_return("127.0.0.1")
      allow(mock_socket).to receive_message_chain(:local_address, :ip_port).and_return(80)
    end

    it "opens a network connection and sends data" do
      expect(mock_socket).to receive(:write).with(data)
      expect(mock_socket).to receive(:close)

      subject.send_network_data(host, port, data)
    end

    it "logs the desired attributes" do
      subject.send_network_data(host, port, data)

      expect(logger).to have_received(:log_activity) do |args|
        expect(args[:type]).to eq("send_network_data")
        expect(args[:username]).to eq(Etc.getlogin)
        expect(args[:destination_address]).to eq(host)
        expect(args[:destination_port]).to eq(port)
        expect(args[:source_address]).to be_a(String)
        expect(args[:source_port]).to be_a(Integer)
        expect(args[:bytes_sent]).to eq(data.bytesize)
        expect(args[:protocol]).to eq("TCP")
        expect(args[:process_name]).to eq($0)
        expect(args[:process_command_line]).to eq($0 + ' ' + ARGV.join(' '))
        expect(args[:process_id]).to eq(789)
        expect(args[:timestamp]).to be_a(String)
      end
    end
  end

  context "starting a process" do
    let(:exec_path) { "/bin/ls" }

    before do
      allow(Process).to receive(:spawn).and_return(789)
    end

    it "runs the specified command" do
      expect(Process).to receive(:spawn).with(exec_path)

      subject.run_process(exec_path)
    end

    it "logs the desired attributes" do
      subject.run_process(exec_path)

      expect(logger).to have_received(:log_activity) do |args|
        expect(args[:type]).to eq("run_process")
        expect(args[:username]).to eq(Etc.getlogin)
        expect(args[:process_name]).to eq(File.basename(exec_path))
        expect(args[:process_id]).to eq(789)
        expect(args[:timestamp]).to be_a(String)
      end
    end
  end
end