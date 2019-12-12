require 'rails_helper'

RSpec.describe LogRepository do
  let(:log_file) { Tempfile.new('logs.txt') }
  let(:time_now) { Time.now }
  let(:log) { Log.new(id: 'a123', created_at: time_now) }

  subject { described_class.new(log_file) }

  after { FileUtils.rm(log_file) }

  describe '#create' do
    context 'when error' do
      it 'creates a log entry with error description' do
        response = { error: 'invalid ID' }
        log.code = 500
        log.status = 'Error'
        log.error_description = response
        subject.create(log)
        _header, *content = File.readlines(log_file)
        line = content[0].strip.split('  ')
        expect(line).to match_array([
          log.id, time_now.to_s, 'Error', '500', response.to_s
        ])
      end
    end

    context 'when ok' do
      it 'creates a log entry' do
        log.code = 200
        log.status = 'Removed'
        subject.create(log)
        _header, *content = File.readlines(log_file)
        parsed_line = content[0].strip.split('  ')
        expect(parsed_line).to match_array([
          log.id, time_now.to_s, 'Removed', '200'
        ])
      end
    end
  end
end