require 'spec_helper'

describe FlexibleConfig::WrappedYaml do
  let(:key) { 'category.subcategory.wrapped_yaml' }

  describe ".get" do
    subject { described_class[key] }

    context "when a default YML config is set" do
      let(:key) { 'category.subcategory.dummy.one' }
      it { should eq 1 }
    end

    context "when a environment-specific YML config is set" do
      before { allow(ENV).to receive(:[]).and_return 'test' }
      let(:key) { 'category.subcategory.dummy.two' }
      it { should eq 2 }
    end
  end
end
