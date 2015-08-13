require 'spec_helper'

RSpec.describe FlexibleConfig::Overview do
  subject(:instance) { described_class.new }

  specify { expect(subject.call).to be_an Hash }

  describe "example category" do
    subject { instance.call }

    let :expected_output do
      "subcategory.wrapped_yaml                |            |  " \
        "CATEGORY_SUBCATEGORY_WRAPPED_YAML             = testing"
    end # Weird spacing due to sprintf column pattern

    specify "it outputs the available configuration" do
      expect(
        subject['category'].first
      ).to eq expected_output
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
