# frozen_string_literal: true

require "spec_helper"

RSpec.describe Decidim::FileAuthorizationHandler::RemoveDuplicatesJob do
  let(:org_a) { create(:organization) }
  let(:org_b) { create(:organization) }

  it "remove duplicates in the database" do
    %w(AAA BBB AAA AAA).each do |doc|
      create(:census_datum, id_document: doc, organization: org_a)
      create(:census_datum, id_document: doc, organization: org_b)
    end
    expect(Decidim::FileAuthorizationHandler::CensusDatum.count).to be 8
    described_class.new.perform org_a
    expect(Decidim::FileAuthorizationHandler::CensusDatum.count).to be 6
    described_class.new.perform org_b
    expect(Decidim::FileAuthorizationHandler::CensusDatum.count).to be 4
  end
end
