shared_examples_for 'Attachable Files' do
  it 'have many attached files' do
    expect(model.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end