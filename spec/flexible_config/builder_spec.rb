require 'spec_helper'

describe FlexibleConfig::Builder do
  subject(:instance) { described_class.new 'base_key' }

  context "with an ENV var set" do
    before { allow(ENV).to receive(:[]).with('BASE_KEY_TEST_ONE').and_return 9 }

    describe "#fetch" do
      subject { instance.fetch 'test_one' }
      it { should eq 9 }
    end

    describe "#[]" do
      subject { instance['test_one'] }
      it { should eq 9 }
    end
  end

  context "with a key that doesn't exist" do
    describe "#fetch" do
      subject { instance.fetch 'test_two' }

      specify { expect { subject }.to raise_error FlexibleConfig::NotFound }
    end

    describe "#[]" do
      subject { instance['test_two'] }

      specify { expect { subject }.to raise_error FlexibleConfig::NotFound }

      context "with a second argument" do
        subject { instance['test_two', 'default'] }
        it { should eq 'default' }
      end
    end
  end
end
