require 'rails_helper'

RSpec.describe RewardOwning, type: :model do
  it { should belong_to(:reward) }
  it { should belong_to(:user) }
end
