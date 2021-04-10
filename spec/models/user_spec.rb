require 'rails_helper'
RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:comments) }
  it { should have_many(:rewards) }
  it { should have_many(:reward_ownings) }
  it { should have_many(:rewards).through(:reward_ownings) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'can be owner of resource' do
    author = create(:user)
    question = create(:question, user: author)
    answer = create(:answer, user: author, question: question)

    expect(author).to be_owner_of(answer)
  end
end
