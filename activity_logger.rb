require 'json'

class ActivityLogger
  def initialize(log_file)
    @log_file = log_file
  end

  def log_activity(activity)
    File.open(@log_file, 'a') do |file|
      file.write(JSON.pretty_generate(@activities))
    end
  end
end