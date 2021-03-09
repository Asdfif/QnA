require 'rails_helper'
RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'can be owner of resource' do
    user = create(:user)
    author = create(:user)
    question = create(:question, user: author)
    answer = create(:answer, user: author, question: question)

    expect(user.own_it?(question)).to be_falsy
    expect(user.own_it?(answer)).to be_falsy
    expect(author.own_it?(question)).to be_truthy
    expect(author.own_it?(answer)).to be_truthy
  end
end
