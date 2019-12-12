require 'rails_helper'

RSpec.describe Backup do
  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:created_at) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:size) }
  it { is_expected.to respond_to(:database) }
end