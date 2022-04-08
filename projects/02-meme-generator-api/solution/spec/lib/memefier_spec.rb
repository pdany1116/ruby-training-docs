require "./lib/memefier"
require "./lib/image_downloader"

RSpec.describe Memefier do
  subject(:memefier) { described_class }
  SOURCE_PATH = "./tmp/original.jpeg"
  DESTINATION_PATH = "./tmp/meme.jpeg"

  describe ".memefy" do
    subject(:memefy) { memefier.memefy(source, destination, text) }

    before :each do
      Dir.mkdir("./tmp") unless Dir.exists?("./tmp")
      ImageDownloader.download("https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg", SOURCE_PATH)
    end

    after :each do
      FileUtils.rm_rf("./tmp/.", secure: true)
    end

    context "with valid image" do
      let(:source) { SOURCE_PATH }
      let(:destination) { DESTINATION_PATH}
      let(:text) { "2 pancakes in the desert..." }

      it "creates a new file on the disk at specified path, with size different than the original one" do
        result = memefy

        File.file?(destination)
        expect(File.size(source)).not_to eq File.size(destination)
      end
    end
  end
end
