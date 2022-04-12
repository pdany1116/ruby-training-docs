require "./lib/memefier"
require "./lib/image_downloader"
require "down"

RSpec.describe Memefier do
  subject(:memefier) { described_class }

  describe ".memefy" do
    subject(:memefy) { memefier.memefy("original.jpeg", text) }

    before :each do
      Dir.mkdir("./tmp") unless Dir.exists?("./tmp")
      ImageDownloader.create.download("https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg", "original.jpeg")
    end

    after :each do
      FileUtils.rm_rf("./tmp/original.jpeg", secure: true)
    end

    context "with valid image" do
      let(:text) { "2 pancakes in the desert..." }

      it "modifies the source file and size is different than the original" do
        initial_size = File.size("./tmp/original.jpeg")

        memefy

        expect(File.file?("./tmp/original.jpeg")).to eq true
        expect(File.size("./tmp/original.jpeg")).not_to eq initial_size
      end
    end
  end
end
