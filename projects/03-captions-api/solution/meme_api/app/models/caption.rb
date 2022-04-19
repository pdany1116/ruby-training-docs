class Caption < ApplicationRecord
  validates :url, :text, presence: true
  validates :caption_url, presence: false
end
