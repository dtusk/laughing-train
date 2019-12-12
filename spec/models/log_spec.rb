require 'rails_helper'

RSpec.describe Log do

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:created_at) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:code) }
  it { is_expected.to respond_to(:error_description) }

  describe '#to_row' do
    let(:time) { Time.now }

    subject do 
      described_class.new(
        id: 'a123', 
        created_at: time, 
        status: 'Error', 
        code: 200, 
        error_description: { error: 'Invalid ID'}
      ).to_row
    end

    let(:expected_result) do
      "a123  #{time.to_s}  Error  200  {:error=>\"Invalid ID\"}"
    end

    it { is_expected.to eq(expected_result) }
  end
end