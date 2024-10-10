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
end