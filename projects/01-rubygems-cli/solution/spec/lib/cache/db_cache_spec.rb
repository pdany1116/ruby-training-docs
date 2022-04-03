require "./lib/cache/db_cache"

RSpec.describe DBCache do
  subject(:cache) { described_class.create }

  describe "#write" do
    subject(:write) { cache.write(key, value) }

    after :context do
      described_class.create.clear_all
    end

    context "with valid key and value" do
      let(:key) { "key" }
      let(:value) { "value" }

      after :each do
        result = cache.read(key)
        expect(result.value).to eq value
      end

      it "returns not nil" do
        expect(write).not_to be nil
      end
    end
  end

  describe "#read" do
    subject(:read) { cache.read(key) }

    after :context do
      described_class.create.clear_all
    end

    context "with valid key" do
      let(:key) { "key" }
      let(:value) { "value" }

      before :each do
        cache.write(key, value)
      end

      it "returns FileCacheEntry with correct value" do
        result = read
        
        expect(result.class).to be CacheEntry
        expect(result.value).to eq value
      end
    end

    context "with valid key, but the gem cache entry is expired" do
      ONE_DAY = 12 * 60 * 60
      let(:key) { "key" }
      let(:value) { "value" }
      let(:expirest_at) { Time.now - ONE_DAY }

      before :each do
        cache.write(key, value, expirest_at)
      end

      it "returns nil" do
        result = read
        
        expect(result).to be nil
      end
    end

    context "with invalid key" do
      let(:key) { "invalid-key" }
      let(:value) { "value" }

      it "returns nil" do
        result = read
        
        expect(result).to be nil
      end
    end
  end
end
