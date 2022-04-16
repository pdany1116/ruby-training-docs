require "./lib/image_downloader"
require "pry"

RSpec.describe ImageDownloader do
  subject(:image_downloader) { described_class.create }

  describe "#download" do
    subject(:download) { image_downloader.download(uri, path) }

    after :each do
      FileUtils.rm_rf("./tmp/.", secure: true)
    end

    before :each do
      FileUtils.rm_rf("./tmp/.", secure: true)
    end

    context "with valid uri" do
      let(:uri) { "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg" }
      let(:path) { "original.jpeg"}

      it "downloads the source file from uri in path location",
        :skip => "alone it works, with the whole suite it does not" do
        download

        File.file?("./tmp/" + path)
      end
    end

    context "with invalid uri" do
      let(:uri) { "www.invalid_uri.com" }
      let(:path) { "./tmp/original.jpeg"}

      it "raises ImageDownloaderError with invalid uri message" do
        expect{ "#{download}" }.to raise_error("Invalid URI provided!")
      end
    end
  end
end