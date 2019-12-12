class BackupsController < ApplicationController
  def remove_backup
    render RemoveBackupService.call(params[:backup_id])
  end
end
