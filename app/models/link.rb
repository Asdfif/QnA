class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :url, presence: true, format: { with: URI::regexp }
  validates :name, presence: true
end
