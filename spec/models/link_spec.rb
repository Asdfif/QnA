require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should_not allow_value('example').for :url }
  it { should allow_value('https://www.google.com/').for :url }

  it 'can be a gist' do
    user = create(:user)
    question = create(:question, user: user)
    url = 'https://gist.github.com/Asdfif/7bc3bea166696968c424dff17fcc485f'
    link = create(:link, linkable: question, name: 'x', url: url)

    expect(link).to be_is_a_gist
  end
end
