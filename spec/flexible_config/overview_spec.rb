require 'spec_helper'

RSpec.describe FlexibleConfig::Overview do
  subject(:instance) { described_class.new }

  specify { expect(subject.call).to be_an Hash }

  describe "example category" do
    subject { instance.call }

    let :expected_output do
      "another_sub.short_syntax                |            |  " \
        "CATEGORY_ANOTHER_SUB_SHORT_SYNTAX             = shorty"
    end # Weird spacing due to sprintf column pattern

    specify "it outputs the available configuration" do
      expect(
        subject['category'].first
      ).to eq expected_output
    end

    specify "it sorts alphabetically" do
      expect(
        subject['category'].first
      ).to be <= subject['category'].last
    end
  end

  describe ".print" do
    subject { instance.print }

    specify "it outputs stuff" do
      expect(Kernel).to receive(:puts).at_least :once
      subject
    end
  end
end
