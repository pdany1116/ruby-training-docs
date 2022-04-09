require "./lib/memefier"
require "down"

RSpec.describe Memefier do
  subject(:memefier) { described_class }
  SOURCE_PATH = "./tmp/original.jpeg"

  describe ".memefy" do
    subject(:memefy) { memefier.memefy(SOURCE_PATH, text) }

    before :each do
      Dir.mkdir("./tmp") unless Dir.exists?("./tmp")
      Down.download("https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg", destination: SOURCE_PATH)
    end

    after :each do
      FileUtils.rm_rf("./tmp/#{SOURCE_PATH}", secure: true)
    end

    context "with valid image" do
      let(:source) { SOURCE_PATH }
      let(:text) { "2 pancakes in the desert..." }

      it "modifies the source file and size is different than the original" do
        initial_size = File.size(source)

        result = memefy

        expect(File.file?(source)).to eq true
        expect(File.size(source)).not_to eq initial_size
      end
    end
  end
end
