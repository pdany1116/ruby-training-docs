require "./lib/db/db"
require "./lib/db/user"

RSpec.describe DB do
  subject(:db) { described_class.create }

  describe ".create" do
    context "with non existing db file" do
      it "confirms that file exists and users table is created" do
        result = db
        
        expect(result).not_to be nil
        expect(File.file?("./db.sqlite3")).to eq true
      end
    end
  end

  describe "#insert" do
    subject(:insert) { db.insert(user) }

    after :context do
      described_class.create.clear_all
    end

    context "with valid user" do
      let(:user) { User.new("username", "password") }

      after :each do
        result = db.find(user)
        expect(result).to eq true
      end

      it "returns not nil" do
        expect(insert).not_to be nil
      end
    end
  end

  describe "#find" do
    subject(:find) { db.find(user) }

    after :context do
      described_class.create.clear_all
    end

    context "with valid user" do
      let(:user) { User.new("username", "password") }

      before :each do
        db.insert(user)
      end

      it "returns " do
        result = find
        
        expect(result).to eq true
      end
    end
  end
end
