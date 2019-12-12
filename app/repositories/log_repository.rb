class LogRepository
  def initialize(file)
    @file = file
    file_exists = File.exist?(@file) && !File.zero?(@file)

    unless file_exists
      initialize_log
    end
  end


  # Creates log entry in specified file
  #
  # @param log [Log]
  def create(log)
    File.open(file, 'a') do |f|
      f.puts(log.to_row)
    end
  end

  private

  attr_reader :file

  def initialize_log
    File.open(file, 'w') do |f|
      f.puts(Log.header)
    end
  end
end