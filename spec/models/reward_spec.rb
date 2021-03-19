require 'rails_helper'
RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }
  it { should have_one(:reward_owning) }
  it { should have_one(:user).through(:reward_owning) }

  it { should_not allow_value('example').for :img_url }
  it { should allow_value('https://www.google.com/').for :img_url }

end
