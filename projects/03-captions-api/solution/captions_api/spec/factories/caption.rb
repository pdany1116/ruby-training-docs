require "faker"
require "factory_bot"

FactoryBot.define do
  factory :caption do
    url { Faker::Internet.url }
    text { Faker::String.random }
    caption_url { Faker::Internet.url(path: Faker::File.file_name(ext: "jpeg")) }
  end
end
