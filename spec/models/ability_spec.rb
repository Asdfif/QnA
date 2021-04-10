require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }

    let(:file) do  
      question.files.attach(io: File.open('/home/asdfif/Rails/qna/spec/rails_helper.rb'), 
                              filename: 'rails_helper.rb', 
                              content_type: "txt"
                             )
      question.files.last
    end

    let(:other_file) do 
      other_question.files.attach(io: File.open('/home/asdfif/Rails/qna/spec/rails_helper.rb'), 
                              filename: 'rails_helper.rb', 
                              content_type: "txt"
                             )
      other_question.files.last
    end

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    context 'questions' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, create(:question, user: user) }
      it { should be_able_to :destroy, create(:question, user: user) }  

      it { should_not be_able_to :update, create(:question, user: other) }
      it { should_not be_able_to :destroy, create(:question, user: other) }
    end

    context 'answers' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, create(:answer, question: question, user: user) }
      it { should be_able_to :destroy, create(:answer, question: question, user: user) }
      it { should be_able_to :make_it_best, create(:answer, question: question, user: user) }

      it { should_not be_able_to :update, create(:answer, question: question, user: other) }
      it { should_not be_able_to :destroy, create(:answer, question: question, user: other) }
      
      context 'Not author of question' do
        subject(:ability) { Ability.new(other) }

        it { should_not be_able_to :make_it_best, create(:answer, question: question, user: user) }
      end
    end

    context 'comments' do
      it { should be_able_to :create, Comment }
    end

    context 'links' do
      it { should be_able_to :create, Link }
      it { should be_able_to :destroy, create(:link, linkable: question) }

      it { should_not be_able_to :destroy, create(:link, linkable: create(:question, user: other)) }
    end

    context 'attachments' do
      it { should be_able_to :delete_file, file }

      it { should_not be_able_to :delete_file, other_file }
    end

    context 'rewards' do
      it { should be_able_to :create, create(:reward, question: question) }
      it { should_not be_able_to :create, create(:reward, question: other_question) }
    end

    context 'votes' do
      it { should be_able_to %i[vote_for vote_against], other_question }
 
      it { should_not be_able_to %i[vote_for vote_against], question }
      it { should_not be_able_to :cancel_vote, question }
    end

    context 'API' do
      it { should be_able_to %i[me others], user }
    end
  end
end
