shared_examples_for "Votable" do
  let(:author) { create(:user) }
  
  it 'count rating' do
    get_model(klass)

    rating

    expect(@model.rating).to eq -1
  end

  private
  
  def get_model(klass)
    case klass
    when :question 
      @model = create(klass, user: author)
    when :answer
      @model = create(klass, user: author, question: create(:question, user: author))
    end
  end

  def rating
    user = create(:user)
    user2 = create(:user)
    user3 = create(:user)
    @model.votes.build(value: -1, user: user).save!
    @model.votes.build(value: -1, user: user2).save!
    @model.votes.build(value: 1, user: user3).save!
  end
end