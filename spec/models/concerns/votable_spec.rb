require 'rails_helper'

shared_examples_for "votable" do
  let(:author) { create(:user) }
  
  klass = described_class.to_s.underscore.to_sym
  case klass
  when :question 
    let!(:model) { create(klass, user: author) }
    context 'model is question' do
      it 'count rating' do
        count_rating
      end
    end
  when :answer
    let!(:model) { create(klass, user: author, question: create(:question, user: author)) }
    context 'model is answer' do
      it 'count rating' do
        count_rating
      end
    end
  end

  private
  
  def count_rating
    user = create(:user)
    user2 = create(:user)
    user3 = create(:user)
    model.votes.build(value: -1, user: user).save!
    model.votes.build(value: -1, user: user2).save!
    model.votes.build(value: 1, user: user3).save!
    
    expect(model.rating).to eq -1
  end
end