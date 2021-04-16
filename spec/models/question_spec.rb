require 'rails_helper'

RSpec.describe Question, type: :model do

  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:subscribes).dependent(:destroy) }
  it { should have_one(:best_answer) }
  it { should have_one(:reward).dependent(:destroy) }
 
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it_behaves_like 'Attachable Files' do
    let(:model) { Question }
  end

  it_behaves_like 'Votable' do
    let(:klass) { :question }
  end

  describe 'Reputation' do
    let(:question) { build(:question, user: create(:user)) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
