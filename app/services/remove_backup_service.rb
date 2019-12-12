class RemoveBackupService
  def initialize(backup_id)
    @backup_id = backup_id
    @log = Log.new(id: backup_id, created_at: Time.now)
    @record = backup_repository.find(backup_id)
  end

  # Removes entry from backups and creates log entry
  #
  # @return [Hash] of state based on existence of record
  def call
    arguments = if record.present?
                  backup_repository.delete(backup_id)
                  assign_log(log, success: true)
                  { status: 200 }
                else
                  response = { error: 'invalid ID' }
                  assign_log(log, success: false, error_description: response)
                  { json: response, status: 500 }
                end
    log_repository.create(log)
    arguments
  end

  def self.call(backup_id)
    new(backup_id).call
  end

  private

  attr_reader :backup_id, :log, :record

  def backup_repository
    backup_file = Rails.root.join('db', 'backups.txt')
    @backup_repository ||= BackupRepository.new(backup_file)
  end

  def log_repository
    log_file = Rails.root.join('public', 'logs.txt')
    @log_repository ||= LogRepository.new(log_file)
  end

  def assign_log(log, success:, error_description: nil)
    if success
      log.code = 200
      log.status = 'Removed'
    else
      log.code = 500
      log.status = 'Error'
      log.error_description = error_description
    end
  end
end