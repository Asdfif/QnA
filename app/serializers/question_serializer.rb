class QuestionSerializer < ActiveModel::Serializer
  attributes :id, 
             :title, 
             :body, 
             :user_id,
             :created_at, 
             :updated_at,
             :files
  has_many :comments
  has_many :links

  def files
    object.files.map do |file|
      file.url
    end
  end
end
