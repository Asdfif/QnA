require 'rails_helper'
RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it { should validate_presence_of :value }

  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe "validation uniqueness user scope votable" do
    subject { Vote.new(value: 1, votable: question, user: user) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:votable_type, :votable_id) }
  end

  describe "validation user is not an author of votable resource" do
    subject { Vote.new(value: 1, votable: question, user: author) }
    it { should_not be_valid }
  end
end
