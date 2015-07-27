require 'spec_helper'

describe FlexibleConfig::WrappedEnv do
  let(:key) { 'TEST_KEY' }
  let(:value) { nil }

  before do
    allow(ENV).to receive(:[]).with(key).and_return value
    allow(ENV).to receive(:[]).with('RAILS_ENV').and_return 'test'
  end

  describe "#[]" do
    subject { described_class[key] }

    context "when it's missing" do
      it { should eq nil }
    end

    context "the value is an empty string" do
      let(:value) { '' }
      it { should eq nil }
    end

    context "the value is 'true'" do
      let(:value) { 'true' }
      it { should eq true }
    end

    context "the value is 'false'" do
      let(:value) { 'false' }
      it { should eq false }
    end
  end

  describe "#fetch" do
    subject { described_class.fetch key }

    context "when it's missing" do
      it "raises an error" do
        expect { subject }.to raise_error FlexibleConfig::NotFound
      end

      context "when block is provided" do
        subject { described_class.fetch(key) { 'true' } }
        it("still normalizes") { should eq true }
      end
    end
  end

  describe "#int" do
    let(:value) { '1' }
    subject { described_class.int key }

    before do
      allow(ENV).to receive(:fetch).with('RAILS_ENV').and_return 'test'
      allow(ENV).to receive(:fetch).with(key).and_return value
    end

    it { should eql value.to_i }

    context "when value is nil" do
      let(:value) { nil }

      it "raises an error" do
        expect { subject }.to raise_error FlexibleConfig::NotFound
      end

      context "but a block is given" do
        subject { described_class.int(key) { 123 } }
        let(:value) { nil }

        it("returns the result of the block") { should eq 123 }
      end
    end
  end

  describe ".override" do
    context "when a value is overridden" do
      let(:key)       { 'SECRET_KEY_BASE' }
      let(:old_value) { ENV[key] }
      let(:new_value) { 'abc' }

      before { described_class.override key, new_value }

      it("overrides the value") { expect(described_class[key]).to eq new_value }

      context "when reset" do
        it "returns to the old value" do
          described_class.reset
          expect(described_class[key]).to eq old_value
        end
      end
    end
  end
end
