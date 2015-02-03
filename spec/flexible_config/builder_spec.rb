require 'spec_helper'

describe FlexibleConfig::Builder do
  subject(:instance) { described_class.new 'base_key' }

  before do
    allow(ENV).to receive(:[]).and_return nil

    { 'RAILS_ENV'             => 'test',
      'BASE_KEY_TEST_ONE'     => 'value',
      'BASE_KEY_FALSE_STRING' => 'false',
      'BASE_KEY_TRUE_STRING'  => 'true',
      'BASE_KEY_SAFE_INT'     => '123',
      'BASE_KEY_UNSAFE_INT'   => '123unsafe',
      'BASE_KEY_SAFE_FLOAT'   => '123.0',
      'BASE_KEY_UNSAFE_FLOAT' => '123.0unsafe'
    }.each do |key, value|
      allow(ENV).to receive(:[]).with(key).and_return value
    end
  end

  context "with an ENV var set" do
    describe "#fetch" do
      subject { instance.fetch 'test_one' }
      it { should eq 'value' }
    end

    describe "#[]" do
      subject { instance['test_one'] }
      it { should eq 'value' }
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

  context "when WrappedEnv#[] returns false" do
    it "returns false without executing the passed block" do
      expect(
        instance.fetch('false_string') { raise 'hell' }
      ).to eq false
    end
  end

  describe "#to_i" do
    context "when the value is a safe integer" do
      subject { instance.to_i 'SAFE_INT' }
      it { should eq 123 }
    end

    context "when the value is an unsafe integer" do
      subject { instance.to_i 'UNSAFE_INT' }

      it "raises an UnsafeConversion error" do
        expect { subject }.to raise_error FlexibleConfig::UnsafeConversion
      end
    end
  end

  describe "#to_f" do
    context "when the value is a safe float" do
      subject { instance.to_f 'SAFE_FLOAT' }
      it { should eq 123.0 }
    end

    context "when the value is an unsafe float" do
      subject { instance.to_f 'UNSAFE_FLOAT' }

      it "raises an UnsafeConversion error" do
        expect { subject }.to raise_error FlexibleConfig::UnsafeConversion
      end
    end
  end
end
