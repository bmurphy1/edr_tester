class EDRTester

  def initialize
    # logger will go here later
  end

  def create_file(file_name)
    File.open(file_name, "w").close
  end
end