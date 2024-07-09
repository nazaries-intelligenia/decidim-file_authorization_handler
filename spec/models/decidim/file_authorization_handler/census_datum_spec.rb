# frozen_string_literal: true

require "spec_helper"
RSpec.describe Decidim::FileAuthorizationHandler::CensusDatum do
  let(:organization) { create(:organization) }

  # rubocop: disable Lint/ConstantDefinitionInBlock
  CensusDatum = Decidim::FileAuthorizationHandler::CensusDatum
  # rubocop: enable Lint/ConstantDefinitionInBlock

  describe "get census for a given identity document" do
    it "returns the last inserted when duplicates" do
      create(:census_datum, id_document: encode_id_document("AAA"))
      last = create(:census_datum, id_document: encode_id_document("AAA"), organization:)
      expect(CensusDatum.search_id_document(organization, "AAA")).to eq(last)
    end

    it "normalizes the document" do
      census = create(:census_datum, id_document: encode_id_document("AAA"), organization:)
      expect(CensusDatum.search_id_document(organization, "a-a-a")).to eq(census)
    end
  end

  context "with #insert_all" do
    it "inserts a collection of values" do
      # rubocop: disable Rails/SkipsModelValidations
      CensusDatum.insert_all(organization, [["1111A", "1990/12/1"], ["2222B", "1990/12/2"]])
      expect(CensusDatum.count).to be 2
      CensusDatum.insert_all(organization, [["1111A", "2001/12/1"], ["3333C", "1990/12/3"]])
      # rubocop: enable Rails/SkipsModelValidations
      expect(CensusDatum.count).to be 4
    end

    context "when values is empty" do
      it "returns without crashing" do # rubocop:disable RSpec/NoExpectationExample
        # rubocop: disable Rails/SkipsModelValidations
        CensusDatum.insert_all(organization, [])
        # rubocop: enable Rails/SkipsModelValidations
      end
    end

    context "when extra columns exist" do
      it "inserts extra columns in the #extras column" do
        # rubocop: disable Rails/SkipsModelValidations
        CensusDatum.insert_all(organization, [
                                 ["1111A", "2001/12/1", "001", "1234"],
                                 ["3333C", "1990/12/3", "ABCD", "01-12/33"],
                               ], %w(POSTAL_CODE DISTRICT))
        # rubocop: enable Rails/SkipsModelValidations

        inserts = CensusDatum.all
        expect(inserts.size).to be 2
        expect(inserts.first.extras).to eq({ "postal_code" => "001", "district" => "1234" })
        expect(inserts.last.extras).to eq({ "postal_code" => "ABCD", "district" => "01-12/33" })
      end
    end
  end

  describe "normalization methods" do
    it "normalizes and encodes the id document" do
      expect(CensusDatum.normalize_and_encode_id_document("1234a"))
        .to eq encode_id_document("1234A")
      expect(CensusDatum.normalize_and_encode_id_document("   1234a  "))
        .to eq encode_id_document("1234A")
      expect(CensusDatum.normalize_and_encode_id_document(")($·$")).to eq ""
      expect(CensusDatum.normalize_and_encode_id_document(nil)).to eq ""
    end

    it "normalizes dates" do
      expect(CensusDatum.parse_date("20/3/1992")).to eq Date.strptime("1992/03/20", "%Y/%m/%d")
      expect(CensusDatum.parse_date("1/20/1992")).to be_nil
      expect(CensusDatum.parse_date("n/3/1992")).to be_nil
    end
  end
end
