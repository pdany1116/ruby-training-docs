require "./lib/image_downloader"

RSpec.describe ImageDownloader do
  subject(:image_downloader) { described_class }

  describe ".download" do
    subject(:download) { image_downloader.download(uri, path) }

    after :each do
      FileUtils.rm_rf("./tmp/.", secure: true)
    end

    before :each do
      Dir.mkdir("./tmp") unless Dir.exists?("./tmp")
    end

    context "with valid uri" do
      let(:uri) { "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg" }
      let(:path) { "./tmp/original.jpeg"}

      it "creates a file on the disk at the specified path" do
        result = download

        File.file?(path)
      end
    end
  end
end
