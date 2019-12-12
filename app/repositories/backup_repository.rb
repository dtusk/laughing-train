class BackupRepository
  def initialize(file)
    @file = file
    @records = read_file(file)
  end

  # Finds record by the given ID from file
  #
  # @param id [Int]
  def find(id)
    @records.find { |record| record.id == id }
  end


  # Deletes record by the given ID from file
  #
  # @param id [Int]
  def delete(id)
    record = find(id)
    return unless record

    delete_from_file(@file, record)
    @records = read_file(@file)
  end

  private

  def read_file(file)
    header, *records = File.readlines(file).reject(&:blank?)
    header = header.split(/ (?=[A-Z])/).map(&:strip)
    records.each_with_object([]) do |record, prod|
      record = record.strip.split('  ')
      result = {}
      header.each_with_index do |column, idx|
        result[column] = record[idx]
      end
      prod << create_backup_record(result)
    end
  end

  def create_backup_record(result)
    Backup.new(
        id: result['ID'],
        created_at: result['Created at'],
        status: result['Status'],
        size: result['Size'],
        database: result['Database']
    )
  end

  def delete_from_file(file, record)
    content = File.readlines(file).reject(&:blank?)
    File.open(file, 'w') do |f|
      content.each do |line|
        f.puts(line) if line.split('  ')[0] != record.id
      end
    end
  end
end