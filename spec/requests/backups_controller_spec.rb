require 'rails_helper'

RSpec.describe BackupsController, type: :request do
  let(:backup_file) { file_fixture('backups.txt') }
  let(:tmp_backup_file) { Tempfile.new('backups') }
  let(:tmp_log_file) { Tempfile.new('log_file') }

  before do
    FileUtils.copy(backup_file, tmp_backup_file)
    allow_any_instance_of(RemoveBackupService).
      to receive(:backup_repository) { BackupRepository.new(tmp_backup_file) }
    allow_any_instance_of(RemoveBackupService).
      to receive(:log_repository) { LogRepository.new(tmp_log_file) }
  end

  after do
    FileUtils.rm(tmp_backup_file)
    FileUtils.rm(tmp_log_file)
  end

  describe 'PUT #remove_backup' do
    context 'when ID exists' do
      subject! { put '/remove-backup', params: { backup_id: 'a810' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when ID does not exists' do
      subject! { put '/remove-backup', params: { backup_id: 'not-existing' } }

      it 'returns status code 500 and error message' do
        expect(response).to have_http_status(:internal_server_error)
        json_body = JSON.parse(response.body).symbolize_keys
        expect(json_body).to eq(error: 'invalid ID')
      end
    end
  end
end