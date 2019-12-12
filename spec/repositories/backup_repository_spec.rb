require 'rails_helper'

RSpec.describe BackupRepository do

  let(:file) { file_fixture('backups.txt') }
  let(:tmp_file) { Tempfile.new('backups') }

  before { FileUtils.copy(file, tmp_file) }
  after { FileUtils.rm(tmp_file) }


  describe '#find' do
    subject! { described_class.new(file).find('a278') }

    it 'returns Backup DTO by the given id' do
      expect(subject).not_to eq(nil)
      expect(subject).to have_attributes(
        id: 'a278',
        created_at: '2019-07-08 00:06:19 +0000',
        status: 'Completed 2019-07-08 00:16:04 +0000',
        size: '479.59MB',
        database: 'DATABASE'
      )
    end
  end

  describe '#delete' do
    subject { described_class.new(tmp_file).delete('a278') }

    it 'deletes the entry in file' do
      expect(subject).not_to eq(nil)
      File.readlines(tmp_file).each do |line|
        expect(line.split('  ')[0]).not_to eq('a278')
      end
    end
  end
end