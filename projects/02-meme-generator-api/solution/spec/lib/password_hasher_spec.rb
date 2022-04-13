require "./lib/password_hasher"

RSpec.describe PasswordHasher do
  subject(:hasher) { described_class }

  describe ".valid?" do
    subject(:valid) { hasher.valid?(hash, plain_text) }

    context "with hash generated from valid password" do
      let(:hash) { hasher.create(plain_text) }
      let(:plain_text) { "password" }

      it "returns true" do
        expect(valid).to eq true
      end
    end
  end
end
