require 'spec_helper'

RSpec.describe FlexibleConfig::NotFound do
  subject(:instance) { described_class.new key }
  let(:key) { 'this.then.that' }

  describe "#message" do
    subject { pp instance.message }

    it { should include 'config/settings/this.yml' }
    it { should include 'THIS_THEN_THAT' }
  end
end
