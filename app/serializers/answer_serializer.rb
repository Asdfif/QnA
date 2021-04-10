class AnswerSerializer < ActiveModel::Serializer
  # include Rails.application.routes.url_helpers

  attributes :id, 
             :body,
             :question_id,
             :user_id,
             :created_at, 
             :updated_at,
             :files
  has_many :comments
  has_many :links

  def files
    object.files.map do |file|
      # rails_blob_url(file, only_path: true)
      file.url
    end
  end
end