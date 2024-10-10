require 'rspec'
require_relative './edr_tester'

RSpec.describe EDRTester do

  subject { EDRTester.new() }

  context "file creation" do
    let(:file_name) { "test_file_creation.txt" }

    after do
      File.delete(file_name) if File.exist?(file_name)
    end

    it "creates a file of specified type and location" do
      subject.create_file(file_name)

      expect(File.exist?(file_name)).to be true
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
  end
end