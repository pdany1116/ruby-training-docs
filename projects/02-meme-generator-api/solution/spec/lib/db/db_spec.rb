require "./lib/db/db"
require "./lib/db/user"
require "sqlite3"

RSpec.describe DB do
  subject(:db) { described_class.create }

  describe ".create" do
    context "with non existing db file" do
      before :each do
        File.delete("./db.sqlite3")
      rescue Errno::ENOENT
        # Ignore exception in case db file does not exist
      end

      it "confirms that db file exists and tables were created" do
        result = db
        
        expect(result).not_to be nil
        expect(File.file?("./db.sqlite3")).to eq true

        test_db = SQLite3::Database.open("./db.sqlite3")
        expect(test_db.table_info("Users")).not_to be nil
        expect(test_db.table_info("UserTokens")).not_to be nil
        test_db.close
      end
    end

    context "with existing db file and no tables" do
      before :each do
        SQLite3::Database.new("./db.sqlite3")
      end

      it "confirms that db file exists and tables were created" do
        result = db
        
        expect(result).not_to be nil
        expect(File.file?("./db.sqlite3")).to eq true

        test_db = SQLite3::Database.open("./db.sqlite3")
        expect(test_db.table_info("Users")).not_to be nil
        expect(test_db.table_info("UserTokens")).not_to be nil
        test_db.close
      end
    end
  end

  describe "#insert_user" do
    subject(:insert_user) { db.insert_user(user) }

    before :context do
      described_class.create.clear_all
    end

    after :context do
      described_class.create.clear_all
    end

    context "with valid user" do
      let(:user) { User.new("username", "password") }

      after :each do
        result = db.user_by_username(user.username)
        expect(result.username).to eq "username"
        expect(result.password).to eq "password"
      end

      it "returns not nil" do
        expect(insert_user).not_to be nil
      end
    end
  end

  describe "#insert_token" do
    subject(:insert_token) { db.insert_token(token) }

    before :context do
      described_class.create.clear_all
      described_class.create.insert_user(User.new("username", "password"))
    end

    after :context do
      described_class.create.clear_all
    end

    context "with valid token and existing user" do
      let(:user) { db.user_by_username("username") }
      let(:token) { Token.new(user.id, "token") }

      after :each do
        results = db.tokens_by_user_id(user.id)
        expect(results.size).to eq 1
        expect(results[0].userId).to eq user.id
        expect(results[0].token).to eq "token"
      end

      it "returns not nil" do
        expect(insert_token).not_to be nil
      end
    end
  end
end
