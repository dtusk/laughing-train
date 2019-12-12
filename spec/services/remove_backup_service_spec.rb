require 'rails_helper'

RSpec.describe RemoveBackupService do
  let(:backup_file) { file_fixture('backups.txt') }
  let!(:tmp_backup_file) { Tempfile.new('backups') }
  let!(:tmp_log_file) { Tempfile.new('log_file') }

  before do
    FileUtils.copy(backup_file, tmp_backup_file)
    allow_any_instance_of(described_class).
      to receive(:backup_repository) { BackupRepository.new(tmp_backup_file) }
    allow_any_instance_of(described_class).
      to receive(:log_repository) { LogRepository.new(tmp_log_file) }
  end

  after do
    FileUtils.rm(tmp_backup_file)
    FileUtils.rm(tmp_log_file)
  end

  describe '.call' do
    subject! { described_class.call(backup_id) }

    context 'when ID exists' do
      let(:backup_id) { 'a810' }

      it { is_expected.to eq(status: 200) }

      it 'removes entry from backups' do
        File.readlines(tmp_backup_file).each do |line|
          expect(line.split('  ')[0]).not_to eq(backup_id)
        end
      end

      it 'adds entry to logs' do
        _header, *content = File.readlines(tmp_log_file)
        parsed_line = content[0].strip.split('  ')
        expect(parsed_line).to match_array([backup_id, anything, 'Removed', '200'])
      end
    end


    context 'when ID does not exists' do
      let(:backup_id) { 'not-existing' }

      it 'returns an error message with status' do
        expect(subject).to eq(
          status: 500,
          json: { error: "invalid ID" }
        )
      end

      it 'adds entry to logs' do
        _header, *content = File.readlines(tmp_log_file)
        parsed_line = content[0].strip.split('  ')
        expect(parsed_line).to match_array([
          backup_id, anything, 'Error', '500', {error: 'invalid ID'}.to_s
        ])
      end
    end
  end
end