require 'spec_helper'

describe ExampleClass, "using the FlexibleConfig.use method to set constants" do
  before do
    allow(ENV).to receive(:[]).and_return nil

    { 'CATEGORY_SUBCATEGORY_ENV_OVERRIDE' => 'overridden',
      'RAILS_ENV' => 'test'
    }.each do |key, value|
      allow(ENV).to receive(:[]).with(key).and_return value
    end

    load 'fixtures/example_class.rb'
  end

  # Specs

  context "when only a default is present" do
    it "behaves correctly" do
      expect(described_class::NO_CONFIG_BUT_DEFAULT).to eq 1
    end
  end

  context "with an ENV override" do
    it "behaves correctly" do
      expect(described_class::ENV_OVERRIDE).to eq 'overridden'
    end
  end

  context "when an environment-specific config is present" do
    it "behaves correctly" do
      expect(described_class::ENVIRONMENT_SPECIFIC).to eq 'test_only'
    end
  end

  context "when a non environment-specific config is present" do
    it "behaves correctly" do
      expect(described_class::DEFAULT_YAML).to eq 'fallback_value'
    end
  end

  context "when no default or config present" do
    subject do
      FlexibleConfig.use 'category.subcategory' do |config|
        BAD_CONSTANT = config.fetch('no_value_exists')
      end
    end

    it "raises a NotFound exception" do
      expect { subject }.to raise_error FlexibleConfig::NotFound
    end
  end
end
