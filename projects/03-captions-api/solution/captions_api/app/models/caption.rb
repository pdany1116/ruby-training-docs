class Caption < ActiveRecord::Base
  validates :url, :text, presence: true
  validates :caption_url, presence: false
end
